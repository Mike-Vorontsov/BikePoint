//
//  StationMarketState.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 10/09/2023.
//

import Foundation
import Combine
import Common

/// State representing a map
final public class StationsMapState: ObservableObject {
    @Published public var markers: [StationMarkerState]
    @Published public var selectedMarker: StationMarkerState? = nil
    
    public init(markers: [StationMarkerState]) {
        self.markers = markers
    }
}

/// State representing a marker on the map
final public class StationMarkerState: Identifiable {
    @Published public var coordinates: Coordinates
    @Published public var title: String
    
    public typealias DidSelect = (() -> ())
    public var didSelect: DidSelect?
    public var id: String { title }
    
    public init(coordinates: Coordinates, title: String, didSelect: DidSelect? = nil) {
        self.didSelect = didSelect
        self.coordinates = coordinates
        self.title = title
    }
}
