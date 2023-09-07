//
//  DistanceConverter.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation
import MapKit

protocol DistanceFormatting {
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
