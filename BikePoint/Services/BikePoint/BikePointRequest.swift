//
//  BikePointRequest.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation

enum BikePointRequest: ApiRequesting {
    typealias ResponseType = [BikePoint]
    
    case allPoints
    
    struct BikePoint: Decodable {
        let commonName: String
        let id: String
        let url: String
        
        let lon: Double
        let lat: Double
        
    }

    var path: String {
        switch self {
        case .allPoints:
            return "/BikePoint"
        }
    }
    
    var query: [URLQueryItem] {
        switch self {
        case .allPoints:
            return []
        }
    }
    
}

extension BikePoint {
    init(dto: BikePointRequest.BikePoint) {
        self.init(
            address: dto.commonName,
            location: Coordinate(latitude: dto.lat, longitude: dto.lon)
        )
    }
}
