//
//  PersistanceModel.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 10/09/2023.
//

import Foundation
import SwiftData

protocol BikePointPersisting {
    func save(_ stations: [BikePoint]) async
    func allStations() async throws -> [BikePoint]
}

final class BikePointStore: BikePointPersisting {
    
    lazy var modelContainer = try! ModelContainer(for: BikePointModel.self)
    
    func save(_ stations: [BikePoint]) async  {
        guard !stations.isEmpty else { return }
        await MainActor.run {
            let context = modelContainer.mainContext
            stations.forEach {
                context.insert(
                    BikePointModel(bikePoint: $0)
                )
            }
        }
    }
    
    func allStations() async throws -> [BikePoint] {
        let fetchDescriptor = FetchDescriptor<BikePointModel>(sortBy: [SortDescriptor(\BikePointModel.name, order: .forward)])

        let results = try await MainActor.run {
            let context = modelContainer.mainContext
            return try context.fetch(fetchDescriptor)
        }
        return results.map {
            BikePoint(dataModel: $0)
        }
    }
}

private extension BikePointStore {
    @Model
    class BikePointModel {
        @Attribute(.unique) let name: String
        let lat: Double
        let lon: Double
        
        var bikes: Int?
        var emptyDocks: Int?
        
        init(name: String, coordinates: Coordinate, bikes: Int? = nil, emptyDocks: Int? = nil) {
            self.name = name
            self.lat = coordinates.latitude
            self.lon = coordinates.longitude
            self.bikes = bikes
            self.emptyDocks = emptyDocks
        }
    }
}

private extension BikePointStore.BikePointModel {
    
    convenience init(bikePoint: BikePoint) {
        self.init(name: bikePoint.address, coordinates: bikePoint.location, bikes: bikePoint.bikes, emptyDocks: bikePoint.slots)
    }
    
}

private extension BikePoint {
    init(dataModel: BikePointStore.BikePointModel) {
        self.init(
            address: dataModel.name,
            slots: dataModel.emptyDocks,
            bikes: dataModel.bikes,
            location: Coordinate(
                latitude: dataModel.lat,
                longitude: dataModel.lon
            )
        )
    }
}
