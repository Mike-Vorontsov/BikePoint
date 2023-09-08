//
//  StationDetailsState.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation

final class StationDetailsState: ObservableObject, Identifiable {
    internal init(name: String, distance: String, address: String) {
        self.name = name
        self.distance = distance
        self.address = address
    }
    
    @Published var name: String
    @Published var distance: String
    @Published var address: String
}
