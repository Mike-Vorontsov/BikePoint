//
//  BikePoint.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation

struct BikePoint {
    let address: String
    let location: Coordinate
    let distance: Double
    
    init(address: String, location: Coordinate, distance: Double = .infinity) {
        self.address = address
        self.location = location
        self.distance = distance
    }
}
