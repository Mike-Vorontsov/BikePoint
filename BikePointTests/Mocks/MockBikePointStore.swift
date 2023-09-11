//
//  MockBikePointStore.swift
//  BikePointTests
//
//  Created by Mykhailo Vorontsov on 11/09/2023.
//

import Foundation
@testable import BikePoint

final class MockBikePointStore: BikePointPersisting {
    
    struct Mocks {
        var saveStations = CallStack<[BikePoint], Void>()
        var allStations = CallStack<Void, [BikePoint]>(mockResults: [])
    }
    var mocks = Mocks()
    
    func save(_ stations: [BikePoint]) async {
        try! mocks.saveStations.record(stations)
    }
    
    func allStations() async throws -> [BikePoint] {
        try mocks.allStations.record(())
    }
}
