//
//  Untitled.swift
//  
//
//  Created by Mykhailo Vorontsov on 11/09/2024.
//

import BikePointApiInterface
import NetworkInterface

public class BikePointApiModule {
    private init() {}
    
    public static var shared: BikePointApiModule = .init()
            
    public func prepareApi(networkService: NetworkFetching) -> BikePointFetching {
        BikePointApi(
            networkService: networkService,
            store: BikePointStore()
        )
    }
}
