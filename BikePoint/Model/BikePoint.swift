//
//  BikePoint.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation

/// Basic BikePoint entity
struct BikePoint {
    let address: String
    let slots: Int?
    let bikes: Int?
    let location: Coordinates
    
    init(address: String, slots: Int?, bikes: Int?, location: Coordinates) {
        self.address = address
        self.slots = slots
        self.bikes = bikes
        self.location = location
    }
}
