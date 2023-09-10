//
//  StationListsState.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 10/09/2023.
//

import Foundation
import Combine

final class StationListsState: ObservableObject {
    @Published var stations: [StationCellState]
    @Published var selectedCell: StationCellState? = nil
    
    init(stations: [StationCellState]) {
        self.stations = stations
    }
}

final class StationCellState: ObservableObject, Identifiable {
    @Published var name: String
    @Published var distance: String
    typealias DidSelect = (() -> ())
    var didSelect: DidSelect
    
    init(name: String, distance: String, didSelect:  @escaping DidSelect = {} ) {
        self.name = name
        self.distance = distance
        self.didSelect = didSelect
    }
}
