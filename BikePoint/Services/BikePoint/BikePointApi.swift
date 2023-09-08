//
//  BikePointApi.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation

protocol BikePointFetching {
    func loadBikePoints() async throws -> [BikePoint]
}

final class BikePointApi: BikePointFetching {
    internal init(networkService: NetworkFecthing) {
        self.networkService = networkService
    }
    
    let networkService: NetworkFecthing
    
    func loadBikePoints() async throws -> [BikePoint] {
        try await networkService
            .load(from: BikePointRequest.allPoints)
            .map {
                BikePoint(dto: $0)
            }
    }
}
