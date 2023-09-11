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
    var mockStore: MockBikePointStore!
    
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
        
        mockStore = MockBikePointStore()
        
        sutApi = .init(networkService: mockService, store: mockStore)
        
    }

    override func tearDownWithError() throws {
        sutApi = nil
        mockService = nil
        mockStore = nil
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
    }
    
    func testStoreNotLoadedWhenApiReturnsBikePointDTO() async throws {
        // Given
        
        // When
        _ = try await sutApi.loadBikePoints()
        
        // Then
        XCTAssertEqual(mockStore.mocks.allStations.callsCount, 0)
    }
    
    func testDataSavedToStoreAsyncWhenApiReturnsBikePointDTO() async throws {
        // Given
        let exp = expectation(description: "waiting for async store to be called")
        mockStore.mocks.saveStations.updateMock { _ in
            exp.fulfill()
        }
        
        // When
        let spyApiResult = try await sutApi.loadBikePoints()
        await fulfillment(of: [exp], timeout: 0.001)
        
        // Then
        XCTAssertEqual(mockStore.mocks.saveStations.callsCount, 1)
        XCTAssertEqual(mockStore.mocks.saveStations.lastCallParams?.count, 1)
        XCTAssertEqual(
            mockStore.mocks.saveStations.lastCallParams?.first?.address,
            spyApiResult.first?.address
        )

    }

    func testBikePointReturnedFromStoreWhenApiThrowsError() async throws {
         
        // Given
        mockService.mocks.loadRequest.updateMock { _ in
            throw FakeError.testError
        }
        mockStore.mocks.allStations.updateMock {
            [BikePoint(address: "Fake from storage", slots: nil, bikes: nil, location: Coordinate(latitude: 0, longitude: 0))]
        }
        
        // When
        let spyBikePoints = try await sutApi.loadBikePoints()
        
        // Then
        XCTAssertEqual(mockStore.mocks.allStations.callsCount, 1)
        XCTAssertEqual(spyBikePoints.count, 1)
        XCTAssertEqual(spyBikePoints.first?.address, "Fake from storage")
    }
}

private enum FakeError: Error {
    case testError
}
