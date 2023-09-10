//
//  NetworkServiceTests.swift
//  BikePointTests
//
//  Created by Mykhailo Vorontsov on 09/09/2023.
//

import XCTest
@testable import BikePoint

final class NetworkServiceTests: XCTestCase {
    
    var mockSession: MockURLSession!
    var sutNetworkService: NetworkService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockSession = MockURLSession(mockStringData: FakeResultType.fakeDataString)
        let fakeConfig = NetworkService.ApiConfig(
            baseUrl: URL(string: "fake://tests.api")!,
            headers: ["fake_header": "true"]
        )
        self.sutNetworkService = NetworkService(
            config: fakeConfig,
            session: mockSession
        )
    }

    override func tearDownWithError() throws {
        sutNetworkService = nil
        mockSession = nil
        try? super.tearDownWithError()
    }

    func testCorrectUrlCalledOnRequest() throws {
        // Given
        let exp = expectation(description: "async api")
        // When
        Task {
            _ = try? await sutNetworkService.load(from: FakeApiRequest())
            exp.fulfill()
        }
        wait(for: [exp])
        // Then
        XCTAssertEqual(mockSession.mocks.dataForRequest.lastCallParams?.url?.absoluteString, "fake://tests.api/fake_path?fake_param=true")
    }
    
    func testCorrectHeadersIncludedIntoRequest() throws {
        // Given
        let exp = expectation(description: "async api")
        // When
        Task {
            _ = try? await sutNetworkService.load(from: FakeApiRequest())
            exp.fulfill()
        }
        wait(for: [exp])
        // Then
        XCTAssertEqual(mockSession.mocks.dataForRequest.lastCallParams?.allHTTPHeaderFields, ["fake_header": "true"])
    }

    func testSessionCalledOnce() async throws {
        // Given
        // When
        _ = try? await sutNetworkService.load(from: FakeApiRequest())
        // Then
        XCTAssertEqual(mockSession.mocks.dataForRequest.callsCount, 1)
    }

    
    func testDataParsedCorrectlyWhenResponseCorrect() async throws {
        // Given
        // When
        let response = try await sutNetworkService.load(from: FakeApiRequest())
        
        // Then
        XCTAssertTrue(response.fake)
    }

    func testErrorWhenWrongDataReceived() async throws {
        // Given
        self.mockSession.mocks.dataForRequest.updateMock { _ in
            (
                FakeResultType.invalidDataString.data(using: .utf8)!,
                HTTPURLResponse(
                    url: URL(string: "fake://api")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )! as URLResponse
            )
        }

        // When
        do {
            _ = try await sutNetworkService.load(from: FakeApiRequest())
            XCTFail("expect error")
        } catch  let error as NetworkService.ServiceError {
            XCTAssertEqual(error.debugString, "parsing")
        } catch {
            XCTFail("expect error")
        }
         
        
    }
    
    func testErrorWheApiCodeNot2xxReceived() async throws {
        // Given
        self.mockSession.mocks.dataForRequest.updateMock { _ in
            (
                FakeResultType.fakeDataString.data(using: .utf8)!,
                HTTPURLResponse(
                    url: URL(string: "fake://api")!,
                    statusCode: 400,
                    httpVersion: nil,
                    headerFields: nil
                )! as URLResponse
            )
        }

        // When
        do {
            _ = try await sutNetworkService.load(from: FakeApiRequest())
            XCTFail("expect error")
        } catch  let error as NetworkService.ServiceError {
            XCTAssertEqual(error.debugString, "api code: 400")
        } catch {
            XCTFail("expect error")
        }
    }

}

// MARK: Fake content to test
private struct FakeResultType: Decodable {
    let fake: Bool
    
    static let fakeDataString =
"""
    {
        \"fake\": true
    }
"""
    
    static let invalidDataString =
"""
    {
        \"fake1\": true
    }
"""

}

private struct FakeApiRequest: ApiRequesting {
    typealias ResponseType = FakeResultType
    
    let path: String = "fake_path"
    let query: [URLQueryItem] = [URLQueryItem(name: "fake_param", value: "true")]
}
