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
    internal init(navigation: Navigating, detailsPresenterResolver: @escaping (() -> (StationDetailsPresenting)), detailsViewResolver: @escaping (() -> (StationDetailsView))) {
        self.navigation = navigation
        self.detailsPresenterResolver = detailsPresenterResolver
        self.detailsViewResolver = detailsViewResolver
    }
    
    private let navigation: Navigating

    private var detailsPresenterResolver: (() -> (StationDetailsPresenting))
    private var detailsViewResolver: (() -> (StationDetailsView))
    
    func dismissDetails() {
        navigation.pop()
    }
    
    func showDetails(for bikePoint: BikePoint) {
        detailsPresenterResolver().selectedBikePoint = bikePoint
        navigation.push(
            view: detailsViewResolver()
        )
    }
}
