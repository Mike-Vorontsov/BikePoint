//
//  StationDetailsState.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation

final class StationDetailsState: ObservableObject, Identifiable {
    init(name: String, distance: String, address: String, coordinates: Coordinate, onBack: (() -> ())? = nil) {
        self.name = name
        self.distance = distance
        self.address = address
        self.coordinates = coordinates
        self.onBack = onBack
    }
    
    @Published var name: String
    @Published var distance: String
    @Published var address: String
    @Published var coordinates: Coordinate
    
    var onBack: (() -> ())?
}
