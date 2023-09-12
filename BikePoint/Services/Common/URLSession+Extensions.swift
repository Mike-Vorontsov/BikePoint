//
//  URLSession+Extensions.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation

/// Protocol describing URL session default async/await method to fetch data. Necessary to create mocks of URL session and test components offline.
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
