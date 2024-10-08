//
//  File.swift
//  BikePointTests
//
//  Created by Mykhailo Vorontsov on 09/09/2023.
//

import Foundation

/// Generic wrapper around particular methods
public struct CallStack<ArgumentType, ResultType> {

    /// Type of the call - should match function's arguments and result type.
    public typealias MockCall = (ArgumentType) throws -> (ResultType)
    private var mock: MockCall

    /// Initialise call stack with particular mocked closure
    /// - Parameter mock: closure describing expected behaviour of test
    public init(mock: @escaping MockCall) {
        self.mock = mock
    }
    
    /// History of all calls with given arguments
    private(set) var history: Array<ArgumentType> = []
    
    /// Latest call
    public var lastCallParams: ArgumentType? { history.last }
    
    /// Number of calls
    public var callsCount: Int { history.count }
    
    
    /// Update existed mock with new one. Didn't change history.
    /// - Parameter newMock: new expected behaviour of test
    public mutating
    func updateMock(_ newMock: @escaping MockCall) {
        self.mock = newMock
    }
    
    /// To be called from particular mock class: record call of the function to the history, and execute closure
    /// - Parameter params: arguments to record
    /// - Returns: result of the mock closure provided
    public mutating
    func record(_ params: ArgumentType) throws -> ResultType {
        history.append(params)
        return try mock(params)
    }
    
}

public extension CallStack {
    init(mockResults: ResultType) {
        mock = { _ in
            mockResults
        }
    }
}

public extension CallStack where ResultType == Void {
    init() {
        mock = { _ in  }
    }
}

public extension CallStack where ArgumentType == Void {
    mutating
    func record() throws -> ResultType {
        try record(())
    }
}
