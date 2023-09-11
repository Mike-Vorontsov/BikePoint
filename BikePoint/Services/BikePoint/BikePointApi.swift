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
    private let networkService: NetworkFecthing
    private let store: BikePointPersisting
    
    init(networkService: NetworkFecthing, store: BikePointPersisting) {
        self.networkService = networkService
        self.store = store
    }
    
    func loadBikePoints() async throws -> [BikePoint] {
        do {
            let response = try await networkService
                .load(from: BikePointRequest.allPoints)
                .map {
                    BikePoint(dto: $0)
                }
            Task {
                await store.save(response)
            }
            return response

        } catch let netError {
            do {
                let response = try await store.allStations()
                return response
            } catch _ {
                throw netError
            }
        }        
    }
}
