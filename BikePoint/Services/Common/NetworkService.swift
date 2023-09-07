//
//  TFLApiService.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation

protocol NetworkFecthing {
    func load<DTO: Decodable>(from request: any ApiRequesting<DTO>) async throws -> DTO
}

protocol ApiRequesting<ResponseType> {
    associatedtype ResponseType: Decodable
    var path: String { get }
    var query: [URLQueryItem] { get }
}

final class NetworkService: NetworkFecthing {
    
    enum ServiceError: Error {
        case wrongResponse(URLResponse)
        case errorCode(Int)
        case network(Error)
        case noData
        case parsing(error: Error, data: Data)
    }
    
    struct ApiConfig {
        let baseUrl: URL
        let headers: [String: String]
    }
    
    let config: ApiConfig
    let session: URLSessionProtocol

    internal init(config: ApiConfig, session: URLSessionProtocol = URLSession.shared) {
        self.config = config
        self.session = session
    }
    
    lazy var decoder: JSONDecoder = .init()
    
    func urlRequest(from request: any ApiRequesting) -> URLRequest {
        let fullUrl = config.baseUrl
            .appending(path: request.path)
            .appending(queryItems: request.query)

        var urlRequest = URLRequest(url: fullUrl)
        
        urlRequest.allHTTPHeaderFields = config.headers
        return urlRequest
    }

    func loadData(for request: URLRequest) async throws -> Data {
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
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
        } catch {
            throw ServiceError.network(error)
        }
    }
    
    func load<DTO: Decodable>(for request: URLRequest) async throws -> DTO {
        let data = try await loadData(for: request)
        
        do {
            return try decoder.decode(DTO.self, from: data)
        } catch {
            throw ServiceError.parsing(error: error, data: data)
        }
    }
    
    func load<DTO: Decodable>(from request: any ApiRequesting<DTO>) async throws -> DTO {
        let urlRequest = self.urlRequest(from: request)
        
        return try await load(for: urlRequest)
    }
}
