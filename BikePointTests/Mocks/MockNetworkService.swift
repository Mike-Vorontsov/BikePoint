//
//  MockNetworkService.swift
//  BikePointTests
//
//  Created by Mykhailo Vorontsov on 10/09/2023.
//

import Foundation
import XCTest

@testable import BikePoint

final class MockNetworkService: NetworkFecthing {
    enum TestsError: Error {
        case mismatchedGenericType
    }
    
    init(mockedResults: Decodable) {
        mocks = Mocks(loadRequest: .init(mockResults: mockedResults))
    }
    
    struct Mocks {
        var loadRequest: CallStack<(any ApiRequesting, Decodable.Type), Decodable>
    }

    var mocks: Mocks
    
    func load<DTO: Decodable>(from request: any ApiRequesting<DTO>) async throws -> DTO {
        let mockedResults = mocks.loadRequest.record((request, DTO.self))
        
        guard let matchedResults = mockedResults as? DTO else {
            XCTFail("Expected DTO generic type \(DTO.self)  do not match mocked result type \(type(of: mockedResults))")
//            XCTSkip("Jumping to next text")
            throw TestsError.mismatchedGenericType
        }
        
        return matchedResults
    }
}

