//
//  StationMarketState.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 10/09/2023.
//

import Foundation
import Combine

/// State representing a map
final class StationsMapState: ObservableObject {
    @Published var markers: [StationMarkerState]
    @Published var selectedMarker: StationMarkerState? = nil
    
    init(markers: [StationMarkerState]) {
        self.markers = markers
    }
}

/// State representing a marker on the map
final class StationMarkerState: Identifiable {
    @Published var coordinates: Coordinates
    @Published var title: String
    
    typealias DidSelect = (() -> ())
    var didSelect: DidSelect?
    var id: String { title }
    
    init(coordinates: Coordinates, title: String, didSelect: DidSelect? = nil) {
        self.didSelect = didSelect
        self.coordinates = coordinates
        self.title = title
    }
}
