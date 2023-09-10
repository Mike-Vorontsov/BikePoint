//
//  BikePointApiTests.swift
//  BikePointTests
//
//  Created by Mykhailo Vorontsov on 10/09/2023.
//

import XCTest
import CoreLocation
@testable import BikePoint

final class BikePointApiTests: XCTestCase {

    var mockService: MockNetworkService!
    var sutApi: BikePointApi!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = .init(
            mockedResults: [
                BikePointRequest.BikePoint(
                    commonName: "FakeBikePoint",
                    id: "fake",
                    url: "fake://url",
                    lon: 0,
                    lat: 42,
                    additionalProperties: []
                )
            ]
        )
        sutApi = .init(networkService: mockService)
    }

    override func tearDownWithError() throws {
        sutApi = nil
        mockService = nil
        try super.tearDownWithError()
    }

    func testServiceUsedWhenApiCalled() async throws {
        // Given
        
        // When
        _ = try await sutApi.loadBikePoints()
        // Then
        XCTAssertEqual(mockService.mocks.loadRequest.callsCount, 1)
    }

    func testBikePointReturnedWhenApiReturnsBikePointDTO() async throws {
        // Given
        
        // When
        let spyBikePoints = try await sutApi.loadBikePoints()
        
        // Then
        XCTAssertEqual(spyBikePoints.count, 1)
        XCTAssertEqual(spyBikePoints.first?.address, "FakeBikePoint")
        XCTAssertEqual(spyBikePoints.first?.location.latitude, 42.0)
        XCTAssertEqual(spyBikePoints.first?.location.longitude, 0.0)
        XCTAssertEqual(spyBikePoints.first?.distance, .infinity)
    }

}
