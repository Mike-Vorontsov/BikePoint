//
//  File.swift
//  BikePointTests
//
//  Created by Mykhailo Vorontsov on 09/09/2023.
//

import Foundation

struct CallStack<Params, Results> {
    public init(mock: @escaping MockCall) {
        self.mock = mock
    }
    
    typealias MockCall = (Params) throws -> (Results)
    var history: Array<Params> = []
    
    var lastCallParams: Params? { history.last }
    var callsCount: Int { history.count }
    
    private var mock: MockCall
    
    mutating
    func updateMock(_ newMock: @escaping MockCall) {
        self.mock = newMock
    }
    
    mutating 
    func record(_ params: Params) throws -> Results {
        history.append(params)
        return try mock(params)
    }
    
    
}

extension CallStack {
    init(mockResults: Results) {
        mock = { _ in
            mockResults
        }
    }
}

extension CallStack where Results == Void {
    init() {
        mock = { _ in  }
    }
}
