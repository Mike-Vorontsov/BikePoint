//
//  StationsListPresenter.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation

struct BikePoint {
    let address: String
    let location: Coordinate
    let distance: Double?
    
    init(address: String, location: Coordinate, distance: Double?) {
        self.address = address
        self.location = location
        self.distance = distance
    }
    
    init(dto: BikePointRequest.BikePoint) {
        self.address = dto.commonName
        self.location = Coordinate(latitude: dto.lat, longitude: dto.lon)
        distance = nil
    }
}

final class StationsListPresenter {
    
    init(
        service: NetworkFecthing,
        mapper: StationsListStateMapping
    ) {
        self.service = service
        self.mapper = mapper
        loadAllPoints()
        monitorLocation()
    }
    
    private var discardBag: [Any] = []
    private let service: NetworkFecthing
    private let locationService: Locating = LocationService()
    
    var latestLocation: Coordinate?
    var latestPoints: [BikePoint]?
    
    lazy var state: StationListsState = .init(stations: [])
    
    var mapper: StationsListStateMapping
    
    func updateStations(stations: [StationCellState]) {
        state.stations = stations
    }
    
    func updateDistance(of points: [BikePoint], to location: Coordinate) -> [BikePoint] {
        points.map {
            BikePoint(
                address: $0.address,
                location: $0.location,
                distance: locationService.distance(from: $0.location, to: location)
            )
        }
        .sorted { $0.distance ?? .infinity < $1.distance ?? .infinity }
        
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
                let dto = try await service.load(from: BikePointRequest.allPoints)
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
