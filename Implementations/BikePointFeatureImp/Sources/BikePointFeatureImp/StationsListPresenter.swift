//
//  StationsListPresenter.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation
import Combine

import Common
import ViewLayerInterface
import BikePointApiInterface
import LocationServiceInterface

/// Protocol for StationsListPresenter public interface
public protocol StationsListPresenting {
    
    /// State for StationsListView
    var listState: StationsListState { get }
    
    /// State for StationsMapView
    var markersState: StationsMapState { get }

    /// Start presenter operations. Invoked automatically on Initialisation at the moment
    func start()
}

/// Presenter to operate with Stations List and Map screen and both views on that screen
final public class StationsListPresenter {
    
    /// Initialise presenter using
    /// - Parameters:
    ///   - bikePointService: service for fetching BikePoints
    ///   - locationService: service for monitoring current location
    ///   - mapper: mapper to convert BikePoint to StationViewCell
    ///   - navigator: navigator to navigate between different screens
    ///   - distanceFormatter: formatter to convert distance number into a string
    public init(
        bikePointService: BikePointFetching,
        locationService: Locating,
        mapper: StationsListStateMapping,
        navigator: StationsNavigating,
        distanceFormatter: DistanceFormatter
    ) {
        self.bikePointService = bikePointService
        self.locationService = locationService
        self.mapper = mapper
        self.navigator = navigator
        self.distanceFormatter = distanceFormatter
        start()
    }
    
    private let bikePointService: BikePointFetching
    private let locationService: Locating
    private let mapper: StationsListStateMapping
    private let distanceFormatter: DistanceFormatting
    
    private let navigator: StationsNavigating
    private var latestLocation: Coordinates?
    @Published private var latestPoints: [BikePoint]?

    private var discardBag: [AnyCancellable] = []
    
    // MARK: - Public
    
    public lazy var listState: StationsListState = .init(stations: [])
    public lazy var markersState: StationsMapState = .init(markers: [])
    
    public func start() {
        setupBindings()
        loadAllPoints()
        monitorLocation()
    }

    // MARK: Helpers
    
    /// Setup Combine bindings
    private func setupBindings() {
        
        // Monitor and react when list of BikePoints changes
        $latestPoints
            .compactMap{ $0 }
            .filter{ !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink { [weak self]  in
                guard let self else { return }
                self.updateStates(with: $0, location: self.locationService.state.location)
            }
            .store(in: &discardBag)

        // Monitor and react when current location changes
        locationService.state
            .$location
            .compactMap{ $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                if let self, let latestPoints = self.latestPoints {
                    updateDistance(of: latestPoints, to: $0)
                }
            }
            .store(in: &discardBag)

    }
    
    /// Helper to update distance for each ViewState
    /// - Parameters:
    ///   - points: all points
    ///   - location: current locations
    private func updateDistance(of points: [BikePoint], to location: Coordinates) {
        // Do not update distance if no points ready yet
        guard listState.stations.count > 0 else { return }
        
        let updatedCells = points
            .map {
                (
                    point: $0,
                    distance: locationService.distance(from: $0.location, to: location)
                )
            }
            .sorted {
                $0.distance < $1.distance
            }
            .map{ input in
                let distance = distanceFormatter.string(for: input.distance)
                let cellState = listState.stations.first {  $0.name == input.point.address }
                ?? mapper.map(input.point, distance: distance) { [weak self] in
                    self?.didSelect(bikePoint: input.point)
                }
                cellState.distance = distance
                return cellState
            }
        self.listState.stations = updatedCells
    }
    
    /// Start monitoring location
    private func monitorLocation() {
        locationService.start()
    }
    
    /// Update states when list of bike points changes
    /// - Parameters:
    ///   - points: bike points
    ///   - location: location to calculate distance from
    private func updateStates(with points: [BikePoint], location: Coordinates?) {
        let cells = points
            .map { (station) -> (distance: Double?, station: BikePoint) in
                let distance: Double?
                if let location {
                    distance = locationService.distance(from: station.location, to: location)
                } else {
                    distance = nil
                }
                return (distance: distance, station: station)
            }
            .sorted{
                $0.distance ?? .infinity < $1.distance ?? .infinity
            }
            .map { (distance, station) in
                let distanceString = distanceFormatter.string(for: distance)
                
                let cell = self.mapper.map(station, distance: distanceString) { [weak self] in
                    self?.didSelect(bikePoint: station)
                }
                return cell
            }
        
        
        let markers = points.map { bikePoint in
            StationMarkerState(
                coordinates: bikePoint.location,
                title: bikePoint.address
            ) { [weak self] in
                self?.didSelect(bikePoint: bikePoint)
            }
        }
        
        listState.stations = cells
        markersState.markers = markers
    }
    
    /// Helper to update selected point
    /// - Parameter bikePoint: bike point that had selected
    private func didSelect(bikePoint: BikePoint) {
        if self.listState.selectedCell?.name == bikePoint.address {
            self.navigator.showDetails(for: bikePoint)
        } else {
            let selectedCell = listState.stations.first{ bikePoint.address == $0.name }
            self.listState.selectedCell = selectedCell
            
            let selectedMarker = markersState.markers.first{ bikePoint.address == $0.title }
            self.markersState.selectedMarker = selectedMarker
        }
        
    }
    
    /// Helper to load all points
    private func loadAllPoints() {
        Task {
            do {
                let points = try await bikePointService.loadBikePoints()
                latestPoints = points                
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
