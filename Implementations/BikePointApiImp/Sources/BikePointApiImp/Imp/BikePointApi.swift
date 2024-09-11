//
//  BikePointApi.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation

import NetworkInterface
import BikePointApiInterface

/// Service to fetch bike points, store locally and fall back to local storage next time network failed
final public class BikePointApi: BikePointFetching {
    private let networkService: NetworkFetching
    private let store: BikePointPersisting
    
    /// Init new service with Network Service and Storage service
    /// - Parameters:
    ///   - networkService: Service to load and Parse data from Network
    ///   - store: Service to store resulted BikePoints locally
    init(networkService: NetworkFetching, store: BikePointPersisting) {
        self.networkService = networkService
        self.store = store
    }
    
    public func loadBikePoints() async throws -> [BikePoint] {
        do {
            // Load DTO from service, and convert it to "operational" data model
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
            // If error - try to fall back to local storage
            do {
                let response = try await store.allStations()
                return response
            } catch _ {
                // If local storage failed - return original network error instead.
                throw netError
            }
        }        
    }
}
