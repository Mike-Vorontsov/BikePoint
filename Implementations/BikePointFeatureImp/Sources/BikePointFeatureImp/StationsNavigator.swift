//
//  StationsNavigator.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation
import UIKit

import Common
import ViewLayerInterface
import BikePointApiInterface

/// Protocol for navigation between Stations screens.
public protocol StationsNavigating {
    /// Show details for particular BikePoint
    /// - Parameter bikePoint: bike point to get details from
    func showDetails(for bikePoint: BikePoint)
    
    /// Dismiss details screen
    func dismissDetails()
}

/// Navigator to perform navigation between different screens in Stations flow and pass necessary parameters to relevant components in needed
final public class StationsNavigator: StationsNavigating {
    private let navigation: Navigating
    
    /// closure to resolve active DetailsPresenter when needed
    private var detailsPresenterResolver: (() -> (StationDetailsPresenting))
    
    /// closure to resolve DetailsView when needed
    private var detailsViewResolver: (() -> (Navigatable))
    
    /// Init new Scene navigator
    /// - Parameters:
    ///   - navigation: UI component used for navigation. Can be UINavigationController
    ///   - detailsPresenterResolver: closure to resolve active DetailsPresenter when needed
    ///   - detailsViewResolver: closure to resolve DetailsView when needed
    public init(
        navigation: Navigating,
        detailsPresenterResolver: @escaping (() -> (StationDetailsPresenting)),
        detailsViewResolver: @escaping (() -> (Navigatable))
    ) {
        self.navigation = navigation
        self.detailsPresenterResolver = detailsPresenterResolver
        self.detailsViewResolver = detailsViewResolver
    }

    public func dismissDetails() {
        navigation.pop()
    }
    
    public func showDetails(for bikePoint: BikePoint) {
        detailsPresenterResolver().selectedBikePoint = bikePoint
        navigation.push(
            view: detailsViewResolver()
        )
    }
}
