//
//  Coordinator.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation
import SwiftUI
import UIKit

import BikePointApiInterface
import LocationServiceInterface
import ViewLayerInterface

import SwiftUIViewLayerImp
import NetworkImp
import BikePointApiImp
import BikePointFeatureImp
import LocationServiceImp

protocol StationsCoordinating {
    func prepareStationsMapView() -> Navigatable
    func prepareStationDetailsView() -> Navigatable
}

protocol Coordinating: StationsCoordinating {}

/// Coordinator to create necessary components for production and inject necessary dependencies.
final class Coordinator: Coordinating {

    // MARK: - Services
    lazy var networkService: NetworkService = .init(config:
            .init(
                baseUrl: URL(string: "https://api.tfl.gov.uk")!,
                headers: [:]
            )
    )
    lazy var locationService: Locating = LocationService()
    
    lazy var bikePointApi: BikePointFetching = BikePointApiModule.shared.prepareApi(networkService: networkService)
    
    // MARK: - Navigation
    lazy var navigator: Navigating  = SwiftUIViewLayerModule.share.prepareNavigator()
    
    lazy var stationsNavigator: StationsNavigating = {
        BikePointFeatureModule.shared.prepareNavigator(
            navigation: navigator,
            detailsPresenterResolver: {[unowned self] in self.detailsPresenter },
            detailsViewResolver: {[unowned self] in self.prepareStationDetailsView() })
    }()
    
    // MARK: - Presenters
    lazy var stationsPresenter: StationsListPresenting = BikePointFeatureModule.shared.prepareStationListPresenter(
        bikePointService: bikePointApi,
        locationService: locationService,
        navigator: stationsNavigator
    )
    
    lazy var detailsPresenter: StationDetailsPresenting = BikePointFeatureModule.shared.prepareStationDetailsPresenter(
        navigator: stationsNavigator,
        locationService: locationService
    )
    
    // MARK: - Views
    func prepareStationDetailsView() -> Navigatable {
        SwiftUIViewLayerModule.share.prepareStationDetailsView(state: detailsPresenter.state)
    }
    
    func prepareStationsMapView() -> Navigatable {
        SwiftUIViewLayerModule.share.prepareStationsMapView(
            mapState: stationsPresenter.markersState,
            listState: stationsPresenter.listState
        )
    }
    
    func prepareRootView() -> AnyView {
        SwiftUIViewLayerModule.share.prepareRootView(startingView: prepareStationsMapView())
    }
}
