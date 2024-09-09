//
//  TFLApiService.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation

import NetworkInterface

/// Service to fetch data from Network  Host, process common errors and parse into convenient DTO objects
final public class NetworkService: NetworkFetching {
    
    /// Network Service error wrapper
    public enum ServiceError: Error {
        case wrongResponse(URLResponse)
        case errorCode(Int)
        case network(Error)
        case noData
        case parsing(error: Error, data: Data)
    }
    
    /// API configuration: host URL, and Headers.
    public struct ApiConfig {
        
        public init(baseUrl: URL, headers: [String : String]) {
            self.baseUrl = baseUrl
            self.headers = headers
        }
        
        let baseUrl: URL
        let headers: [String: String]
    }
    
    private let config: ApiConfig
    private let session: URLSessionProtocol
    
    /// Initialise new Service using provided configuration and session
    /// - Parameters:
    ///   - config: configuration with Host and Auth headers
    ///   - session: URL session to actually perform request. Foundation's URL shared session by default  or can be switched to a mock for testing.
    public init(config: ApiConfig, session: URLSessionProtocol = URLSession.shared) {
        self.config = config
        self.session = session
    }
    
    /// Potentially decoders can be mocked and injected internally for testing, however i don't see any reasons to do so.
    private lazy var decoder: JSONDecoder = .init()
    
    // MARK: - Public
    public func load<DTO: Decodable>(from request: any ApiRequesting<DTO>) async throws -> DTO {
        let urlRequest = self.urlRequest(from: request)
        
        return try await load(for: urlRequest)
    }
    
    // MARK: - Private helpers
    /// Helper function to convert API Request into native URL request
    /// - Parameter request: request to conver
    /// - Returns: URL request to use with native URL session
    private func urlRequest(from request: any ApiRequesting) -> URLRequest {
        let fullUrl = config.baseUrl
            .appending(path: request.path)
            .appending(queryItems: request.query)

        var urlRequest = URLRequest(url: fullUrl)
        
        urlRequest.allHTTPHeaderFields = config.headers
        return urlRequest
    }
    
    /// Helper method to Load Data from URL Request and process common network errors (excluding parsing)
    /// - Parameter request: URL request to perform
    /// - Returns: Data from endpoint or throws ServiceError
    private func loadData(for request: URLRequest) async throws -> Data {
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw ServiceError.wrongResponse(response)
            }
            
            guard (200..<300).contains(response.statusCode) else {
                throw ServiceError.errorCode(response.statusCode)
            }
            
            guard !data.isEmpty else {
                throw ServiceError.noData
            }
            
            return data
        } catch let error as ServiceError {
            throw error
        } catch {
            throw ServiceError.network(error)
        }
    }
    
    /// Helper to load and parse object in DTO using API request
    /// - Parameter request: API Requests contains path, query and expected response type
    /// - Returns: parsed DTO object
    private func load<DTO: Decodable>(for request: URLRequest) async throws -> DTO {
        let data = try await loadData(for: request)
        
        do {
            return try decoder.decode(DTO.self, from: data)
        } catch {
            throw ServiceError.parsing(error: error, data: data)
        }
    }

}
