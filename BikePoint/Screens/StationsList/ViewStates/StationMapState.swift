//
//  StationMarketState.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 10/09/2023.
//

import Foundation
import Combine

final class StationsMapState: ObservableObject {
    
    internal init(markers: [StationMarkerState]) {
        self.markers = markers
    }
    
    @Published var markers: [StationMarkerState]
}

final class StationMarkerState: Identifiable {
    internal init(coordinates: Coordinate, title: String, didSelect:  DidSelect? = nil) {
        self.didSelect = didSelect
        self.coordinates = coordinates
        self.title = title
        
    }
    
    @Published var coordinates: Coordinate
    @Published var title: String

    typealias DidSelect = (() -> ())
    var didSelect: DidSelect?
    var id: String { title }
}
