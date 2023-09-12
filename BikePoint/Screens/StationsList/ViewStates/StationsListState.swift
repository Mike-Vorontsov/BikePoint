//
//  StationsListState.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 10/09/2023.
//

import Foundation
import Combine

/// Thin ViewState representing List of Stations. No logic allowed here.
final class StationsListState: ObservableObject {
    @Published var stations: [StationCellState]
    @Published var selectedCell: StationCellState? = nil
    
    init(stations: [StationCellState]) {
        self.stations = stations
    }
}

/// View state representing particular element of the List. No logic allowed here.
final class StationCellState: ObservableObject, Identifiable, Equatable {
    static func == (lhs: StationCellState, rhs: StationCellState) -> Bool {
        lhs.id == rhs.id
    }
    
    
    @Published var name: String
    @Published var distance: String
    @Published var comment: String
     
    typealias DidSelect = (() -> ())
    var didSelect: DidSelect
    
    init(name: String, distance: String, comment: String, didSelect: @escaping StationCellState.DidSelect = {}) {
        self.name = name
        self.distance = distance
        self.comment = comment
        self.didSelect = didSelect
    }
}
