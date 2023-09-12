//
//  StationsListStateMapper.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation
import MapKit

/// Protocol for component that maps BikePoint model to particular Cell ViewState
protocol StationsListStateMapping {
    /// Map BikePoint model to particular ViewState
    /// - Parameters:
    ///   - point: BikePoint to map
    ///   - distance: Formatted string to be used as Distance property of ViewState
    ///   - didSelect: closure to be invoked when particular cell selected
    /// - Returns: configured and ready to use StationCellState
    func map(_ point: BikePoint, distance: String, didSelect: @escaping ()->() ) -> StationCellState
}

/// Mapper to convert BikePoint model to particular Cell ViewState
final class StationsListStateMapper: StationsListStateMapping {
    
    func map(_ point: BikePoint, distance: String, didSelect: @escaping ()->() ) -> StationCellState {
        var comment = ["Available -"]
        if let bikes = point.bikes {
            comment.append("bikes: \(bikes);")
        }
        if let docks = point.slots {
            comment.append("empty docks: \(docks)")
        }
        
        return .init(
            name: point.address,
            distance: distance,
            comment: comment.joined(separator: " "),
            didSelect: didSelect
        )
    }
}
