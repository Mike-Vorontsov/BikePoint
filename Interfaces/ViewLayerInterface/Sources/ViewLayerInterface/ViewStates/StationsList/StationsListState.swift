//
//  StationsListState.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 10/09/2023.
//

import Foundation
import Combine

/// Thin ViewState representing List of Stations. No logic allowed here.
final public class StationsListState: ObservableObject {
    @Published public var stations: [StationCellState]
    @Published public var selectedCell: StationCellState? = nil
    
    public init(stations: [StationCellState]) {
        self.stations = stations
    }
}

/// View state representing particular element of the List. No logic allowed here.
final public class StationCellState: ObservableObject, Identifiable, Equatable {
    public static func == (lhs: StationCellState, rhs: StationCellState) -> Bool {
        lhs.id == rhs.id
    }
    
    
    @Published public var name: String
    @Published public var distance: String
    @Published public var comment: String
     
    public typealias DidSelect = (() -> ())
    public var didSelect: DidSelect
    
    public init(name: String, distance: String, comment: String, didSelect: @escaping StationCellState.DidSelect = {}) {
        self.name = name
        self.distance = distance
        self.comment = comment
        self.didSelect = didSelect
    }
}
