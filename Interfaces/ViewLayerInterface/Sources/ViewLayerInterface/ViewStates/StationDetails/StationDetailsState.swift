//
//  StationDetailsState.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation
import Common

/// State representing Details of particular BikeStation
final public class StationDetailsState: ObservableObject, Identifiable {
    public init(name: String, distance: String, address: String, coordinates: Coordinates, onBack: (() -> ())? = nil) {
        self.name = name
        self.distance = distance
        self.address = address
        self.coordinates = coordinates
        self.onBack = onBack
    }
    
    @Published public var name: String
    @Published public var distance: String
    @Published public var address: String
    @Published public var coordinates: Coordinates
    
    public var onBack: (() -> ())?
}
