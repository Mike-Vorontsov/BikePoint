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
        
        let additionalProperties: [AddOn]
        
        var addOns: [AddOn.Key: Any] {
            additionalProperties.reduce(into: [:]) {
                guard let key = AddOn.Key(rawValue: $1.key) else { return }
                
                let value: Any = Int($1.value) ?? Double($1.value) ?? Bool($1.value) ?? $1.value as Any
                
                $0[key] = value
            }
        }
        
    }
        
    struct AddOn: Decodable {
        enum Key: String, Decodable {
            case terminalName = "TerminalName"
            case locked = "Locked"
            case bikes = "NbBikes"
            case emptyDocks = "NbEmptyDocks"
        }
        let key: String
        let value: String
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
            slots: dto.addOns[.emptyDocks] as? Int,
            bikes: dto.addOns[.bikes] as? Int,
            location: Coordinate(latitude: dto.lat, longitude: dto.lon)
        )
    }
}
