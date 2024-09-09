//
//  MockURLSession.swift
//  BikePointTests
//
//  Created by Mykhailo Vorontsov on 10/09/2023.
//

import Foundation

import TestUtils
import NetworkInterface

final class MockURLSession: URLSessionProtocol {
    
    init(mockStringData: String, statusCode: Int = 200) {
        mocks = Mocks(
            dataForRequest: .init(
                mockResults: (
                    (
                        mockStringData.data(using: .utf8)!, 
                        HTTPURLResponse(
                            url: URL(string: "fake://api")!,
                            statusCode: statusCode,
                            httpVersion: nil,
                            headerFields: nil
                        )! as URLResponse
                    )
                )
            )
        )
    }
    
    struct Mocks {
        var dataForRequest: CallStack<URLRequest, (Data, URLResponse)>
    }

    var mocks: Mocks
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try mocks.dataForRequest.record(request)
    }
}
