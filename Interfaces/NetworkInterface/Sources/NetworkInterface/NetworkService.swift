//
//  TFLApiService.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation

/// Protocol describing API fetching service.
public protocol NetworkFetching {
    /// Load DTO object using particular API request.
    /// - Parameter request: request containing path, query and expected response DTO type
    /// - Returns: parsed DTO type or throws error
    func load<DTO: Decodable>(from request: any ApiRequesting<DTO>) async throws -> DTO
}

///  Protocol for API Requests, containing URL  path and query params and  type of expected DTO response. Can be expanded to include request methods, body, etc. if needed
public protocol ApiRequesting<ResponseType> {
    associatedtype ResponseType: Decodable
    var path: String { get }
    var query: [URLQueryItem] { get }
}
