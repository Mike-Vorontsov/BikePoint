//
//  StationsListStateMapper.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation
import MapKit

protocol StationsListStateMapping {
    func map(_ point: BikePoint, distance: String, didSelect: @escaping ()->() ) -> StationCellState
}

final class StationsListStateMapper: StationsListStateMapping {
    
    func map(_ point: BikePoint, distance: String, didSelect: @escaping ()->() ) -> StationCellState {
        var comment = ["Available -"]
        if let bikes = point.bikes {
            comment.append("bikes: \(bikes)")
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
