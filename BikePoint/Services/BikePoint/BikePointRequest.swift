//
//  BikePointRequest.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation

/// Enum describing all API requests related to fetching array of BikePoint
enum BikePointRequest: ApiRequesting {
    /// Actually it's only one request at the moment
    case allPoints
    
    /// Expected result type
    typealias ResponseType = [BikePoint]
    
    /// Path for particular request
    var path: String {
        switch self {
        case .allPoints:
            return "/BikePoint"
        }
    }
    
    /// Query Items for particular request
    var query: [URLQueryItem] {
        switch self {
        case .allPoints:
            return []
        }
    }
}
extension BikePointRequest {
    /// Particular DTO object. I prefer to keep DTO isolated from internal Model. Not only DTO is subjected to changes that otherwise can have huge impact on entire app, but although it allows to use same Model for mixing responses of different APIs, potentially enabling to plug-in any other shared bike services later.
    struct BikePoint: Decodable {
        let commonName: String
        let id: String
        let url: String
        
        let lon: Double
        let lat: Double
        
        // Bike point response keep some essential data in form of AdditionalProperties with key and string value. It's more convenient to parse that collection as it was received from backed and use convenience property for matching it to particular parameters
        let additionalProperties: [AddOn]
        
        //  Properties in more convinient from of Dictionary with fixed key type.
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
    
    
 
    
}

extension BikePoint {
    /// Initialise internal data model using DTO
    /// - Parameter dto: backend response
    init(dto: BikePointRequest.BikePoint) {
        self.init(
            address: dto.commonName,
            slots: dto.addOns[.emptyDocks] as? Int,
            bikes: dto.addOns[.bikes] as? Int,
            location: Coordinates(latitude: dto.lat, longitude: dto.lon)
        )
    }
}
