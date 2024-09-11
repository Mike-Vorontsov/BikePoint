//
//  DistanceConverter.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation
import MapKit

/// Formatter to present distance in human readable way
public protocol DistanceFormatting {
    /// Format any given distance to the string
    /// - Parameter distance: distance. Can be optional.
    /// - Returns: String representing the distance.
    func string(for distance: Double?) -> String
}

final public class DistanceFormatter: DistanceFormatting {
    public init() {}    
 
    private lazy var distanceFormatter: MKDistanceFormatter = {
       let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        formatter.units = .metric
        return formatter
    }()
    
    public func string(for distance: Double?) -> String {
        guard let distance else {
            return "-"
        }
        return distanceFormatter.string(fromDistance: distance)
        
    }
}
