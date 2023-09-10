//
//  TestExtensions.swift
//  BikePointTests
//
//  Created by Mykhailo Vorontsov on 10/09/2023.
//

import Foundation
@testable import BikePoint

extension NetworkService.ServiceError {
    var debugString: String {
        switch self {
        case .wrongResponse:
            return "wrong response"
        case .errorCode(let code):
            return "api code: \(code)"
        case .network:
            return "net"
        case .noData:
            return "no data"
        case .parsing:
            return "parsing"
        }
    }
}
