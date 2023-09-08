//
//  StationsListStateMapper.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation
import MapKit

protocol StationsListStateMapping {
    func map(_ dto: BikePoint) -> StationCellState
}

final class StationsListStateMapper: StationsListStateMapping {
    
    let distanceFormatter: DistanceFormatting = DistanceFormatter()

 
    func map(_ point: BikePoint) -> StationCellState {
        .init(
            name: point.address,
            distance: distanceFormatter.string(for: point.distance)
        )
    }
}
