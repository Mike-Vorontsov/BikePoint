//
//  StationsListStateMapper.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation
import MapKit

protocol StationsListStateMapping {
    func map(_ point: BikePoint, didSelect: @escaping ()->() ) -> StationCellState
}

final class StationsListStateMapper: StationsListStateMapping {
    
    let distanceFormatter: DistanceFormatting = DistanceFormatter()
 
    func map(_ point: BikePoint, didSelect: @escaping ()->() ) -> StationCellState {
        var comment = ["Available -"]
        if let bikes = point.bikes {
            comment.append("bikes: \(bikes)")
        }
        if let docks = point.slots {
            comment.append("empty docks: \(docks)")
        }
        
        return .init(
            name: point.address,
            distance: distanceFormatter.string(for: point.distance) + " away",
            comment: comment.joined(separator: " "),
            didSelect: didSelect
        )
    }
}
