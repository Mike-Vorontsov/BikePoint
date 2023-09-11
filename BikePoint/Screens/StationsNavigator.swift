//
//  StationsNavigator.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation
import UIKit

protocol StationsNavigating {
    func showDetails(for bikePoint: BikePoint)
    func dismissDetails() 
}

final class StationsNavigator: StationsNavigating {
    internal init(navigator: Navigating, detailsPresenterResolver: @escaping (() -> (StationDetailsPresenting)), detailsViewResolver: @escaping (() -> (StationDetailsView))) {
        self.navigator = navigator
        self.detailsPresenterResolver = detailsPresenterResolver
        self.detailsViewResolver = detailsViewResolver
    }
    
//    internal init(navigator: Navigating, coordinator: StationsCoordinating, detailsPresenter: StationDetailsPresenter) {
//        self.navigator = navigator
//        self.coordinator = coordinator
//        self.detailsPresenter = detailsPresenter
//    }
    
    
    private let navigator: Navigating
    
    private var detailsPresenterResolver: (() -> (StationDetailsPresenting))
    private var detailsViewResolver: (() -> (StationDetailsView))

    
    func dismissDetails() {
        navigator.pop()
    }
    
    func showDetails(for bikePoint: BikePoint) {
        detailsPresenterResolver().selectedBikePoint = bikePoint
        navigator.push(
            view: detailsViewResolver()
        )
    }
}
