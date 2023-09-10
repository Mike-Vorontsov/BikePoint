//
//  URLSession+Extensions.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
