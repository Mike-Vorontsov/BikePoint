//
//  StationsListPresenter.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation

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
    private let navigator: StationsNavigating

    private var discardBag: [Any] = []

    private var latestLocation: Coordinate?
    private var latestPoints: [BikePoint]?
    
    lazy var state: StationListsState = .init(stations: [])
    lazy var markersState: StationsMapState = .init(markers: [])
    
    // MARK: Helpers
    
    func start() {
        loadAllPoints()
        monitorLocation()
    }
    
    private func updateStations(stations: [StationCellState]) {
        state.stations = stations
    }
    
    private func updateDistance(of points: [BikePoint], to location: Coordinate) -> [BikePoint] {
        points
            .map {
                BikePoint(
                    address: $0.address,
                    location: $0.location,
                    distance: locationService.distance(from: $0.location, to: location)
                )
            }
            .sorted { $0.distance < $1.distance }
        
    }
    
    private func monitorLocation() {
        locationService
            .subscribe { [weak self] location in
                self?.latestLocation = location

                if let self, let latestPoints = self.latestPoints {
                    let points = updateDistance(of: latestPoints, to: location)
                    self.updateState(with: points, location: location)
                }
            }
            .store(in: &discardBag)
    }
    
    private func updateState(with points: [BikePoint], location: Coordinate) {
        state.stations = points.map { bikePoint in
            self.mapper.map(bikePoint) { [weak self] in
                self?.didSelect(bikePoint: bikePoint)
            }
        }
        markersState.markers = points.enumerated().map { (offset, bikePoint) in
            StationMarkerState(
                coordinates: bikePoint.location,
                title: bikePoint.address
            ) { [weak self] in
                self?.didSelect(bikePoint: bikePoint)
            }
        }
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

                if let latestLocation {
                    let updatedPoints = updateDistance(of: points, to: latestLocation)
                    
                    await MainActor.run {
                        self.updateState(with: updatedPoints, location: latestLocation)
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
