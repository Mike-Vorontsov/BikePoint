//
//  LocationService.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation
import CoreLocation
import Combine

import Common

/// Protocol describing interface for LocationService
public protocol Locating {
    ///  State of current location. Can be used for subscribing for current location
    var state: LocationState { get }
    
    
    /// Start location tracking
    func start()
    
    /// Stop location tracking
    func stop()
    
    /// Calculate distance between to coordinates, in meters
    func distance(from coordinatesA: Coordinates, to coordinatesB: Coordinates) -> Double
    
    /// Calculate nearest postal address to specific coordinates, format it to a single line string.
    func address(for coordinates: Coordinates) async throws -> String?
}
