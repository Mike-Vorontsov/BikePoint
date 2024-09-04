//
//  DistanceConverter.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation
import MapKit

/// Formatter to present distance in human readable way
protocol DistanceFormatting {
    /// Format any given distance to the string
    /// - Parameter distance: distance. Can be optional.
    /// - Returns: String representing the distance.
    func string(for distance: Double?) -> String
}

final class DistanceFormatter: DistanceFormatting {
 
    lazy var distanceFormatter: MKDistanceFormatter = {
       let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        formatter.units = .metric
        return formatter
    }()
    
    func string(for distance: Double?) -> String {
        guard let distance else {
            return "-"
        }
        return distanceFormatter.string(fromDistance: distance)
        
    }
}
