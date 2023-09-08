//
//  StationsListPresenter.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation

final class StationsListPresenter {
    
    init(
        netService: NetworkFecthing,
        locationService: Locating,
        mapper: StationsListStateMapping
    ) {
        self.fetchingService = netService
        self.locationService = locationService
        self.mapper = mapper

        start()
    }
    
    private let fetchingService: NetworkFecthing
    private let locationService: Locating
    private var mapper: StationsListStateMapping

    private var discardBag: [Any] = []

    private var latestLocation: Coordinate?
    private var latestPoints: [BikePoint]?
    
    lazy var state: StationListsState = .init(stations: [])
    
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
                    self.updateStations(stations: points.map(self.mapper.map(_:)))
                }
            }
            .store(in: &discardBag)
    }
    
    private func loadAllPoints() {
        Task {
            do {
                let dto = try await fetchingService.load(from: BikePointRequest.allPoints)
                let points = dto.map{ BikePoint(dto: $0) }
                latestPoints = points

                if let latestLocation {
                    let updatedPoints = updateDistance(of: points, to: latestLocation)
                    
                    await MainActor.run {
                        updateStations(stations: updatedPoints.map(mapper.map(_:)))
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
