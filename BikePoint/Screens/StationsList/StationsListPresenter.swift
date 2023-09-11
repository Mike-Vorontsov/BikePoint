//
//  StationsListPresenter.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation
import Combine

final class StationsListPresenter {
    
    init(
        bikePointService: BikePointFetching,
        locationService: Locating,
        mapper: StationsListStateMapping,
        navigator: StationsNavigating
    ) {
        self.bikePointService = bikePointService
        self.locationService = locationService
        self.mapper = mapper
        self.navigator = navigator
        start()
    }
    
    private let bikePointService: BikePointFetching
    private let locationService: Locating
    private let mapper: StationsListStateMapping
    private let distanceFormatter: DistanceFormatting = DistanceFormatter()
    
    private let navigator: StationsNavigating
    
    private var discardBag: [AnyCancellable] = []
    
    private var latestLocation: Coordinate?
    @Published private var latestPoints: [BikePoint]?
    
    lazy var state: StationsListState = .init(stations: [])
    lazy var markersState: StationsMapState = .init(markers: [])
    
    // MARK: Helpers
    
    func start() {
        setupBindings()
        loadAllPoints()
        monitorLocation()
    }
    
    private func setupBindings() {
        $latestPoints
            .compactMap{ $0 }
            .filter{ !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink { [weak self]  in
                guard let self else { return }
                self.updateStates(with: $0, location: self.locationService.state.location)
            }
            .store(in: &discardBag)

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
    
    private func updateDistance(of points: [BikePoint], to location: Coordinate) {
        // Do not update distance if no points ready yet
        guard state.stations.count > 0 else { return }
        
        //        Task {
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
                let cellState = state.stations.first {  $0.name == input.point.address }
                ?? mapper.map(input.point, distance: distance) { [weak self] in
                    self?.didSelect(bikePoint: input.point)
                }
                cellState.distance = distance
                return cellState
            }
        self.state.stations = updatedCells
    }
    
    private func monitorLocation() {
        locationService.start()
    }
    
    private func updateStates(with points: [BikePoint], location: Coordinate?) {
        let cells = points
            .map { (station) -> (distance:Double?, station: BikePoint) in
                let distance: Double?
                if let location {
                    distance = locationService.distance(from: station.location, to: location)
                } else {
                    distance = nil
                }
                return (distance:distance, station: station)
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
        
        state.stations = cells
        markersState.markers = markers
    }
    
    private func didSelect(bikePoint: BikePoint) {
        if self.state.selectedCell?.name == bikePoint.address {
            self.navigator.showDetails(for: bikePoint)
        } else {
            let selectedCell = state.stations.first{ bikePoint.address == $0.name }
            self.state.selectedCell = selectedCell
            
            let selectedMarker = markersState.markers.first{ bikePoint.address == $0.title }
            self.markersState.selectedMarker = selectedMarker
        }
        
    }
    
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
