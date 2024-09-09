//
//  Coordinates.swift
//  
//
//  Created by Mykhailo Vorontsov on 09/09/2024.
//

import Combine
import Common

/// Public subscription interface to overcome limitations that published properties not allowed in protocol
final public class LocationState: ObservableObject {
    public init(location: Coordinates? = nil) {
        self.location = location
    }
    
    @Published public var location: Coordinates?
}
