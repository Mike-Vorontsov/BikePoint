//
//  StationsNavigator.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation

protocol StationsNavigating {
    func showDetails(for bikePoint: BikePoint)
}

final class StationsNavigator: StationsNavigating {
    internal init(navigator: Navigating, coordinator: StationsCoordinating, detailsPresenter: StationDetailsPresenter) {
        self.navigator = navigator
        self.coordinator = coordinator
        self.detailsPresenter = detailsPresenter
    }
    
    let navigator: Navigating
    let coordinator: StationsCoordinating
    let detailsPresenter: StationDetailsPresenter
    
    func showDetails(for bikePoint: BikePoint) {
        detailsPresenter.selectedBikePoint = bikePoint
        navigator.push(
            view: coordinator.prepareStationDetailsView()
        )
    }
}
