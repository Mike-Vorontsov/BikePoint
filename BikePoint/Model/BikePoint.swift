//
//  BikePoint.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation

struct BikePoint {
    let address: String
    let slots: Int?
    let bikes: Int?
    let location: Coordinate
    let distance: Double
    
    init(address: String, slots: Int?, bikes: Int?, location: Coordinate, distance: Double) {
        self.address = address
        self.slots = slots
        self.bikes = bikes
        self.location = location
        self.distance = distance
    }
}
