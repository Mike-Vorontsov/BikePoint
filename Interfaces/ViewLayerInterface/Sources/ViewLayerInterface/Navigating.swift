//
//  Navigating.swift
//
//
//  Created by Mykhailo Vorontsov on 09/09/2024.
//

public protocol Navigatable {}

/// Convenience protocol for basic navigation
public protocol Navigating {
    func push(view: some Navigatable)
    func pop()
}
