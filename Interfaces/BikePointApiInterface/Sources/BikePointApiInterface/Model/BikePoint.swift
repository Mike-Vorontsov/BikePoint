//
//  BikePoint.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation
import Common

/// Basic BikePoint entity
public struct BikePoint {
    public let address: String
    public let slots: Int?
    public let bikes: Int?
    public let location: Coordinates
    
    public init(address: String, slots: Int?, bikes: Int?, location: Coordinates) {
        self.address = address
        self.slots = slots
        self.bikes = bikes
        self.location = location
    }
}
