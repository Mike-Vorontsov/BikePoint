//
//  BikePointPersisting.swift
//  
//
//  Created by Mykhailo Vorontsov on 09/09/2024.
//

public protocol BikePointPersisting {
    func save(_ stations: [BikePoint]) async
    func allStations() async throws -> [BikePoint]
}

