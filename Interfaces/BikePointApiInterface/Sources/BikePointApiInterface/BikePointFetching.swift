//
//  BikePointFetching.swift
//  
//
//  Created by Mykhailo Vorontsov on 09/09/2024.
//


/// Protocol describing service to fetch BikePoints
public protocol BikePointFetching {
    /// Load all bike points
    /// - Returns: collection of bike points
    func loadBikePoints() async throws -> [BikePoint]
}
