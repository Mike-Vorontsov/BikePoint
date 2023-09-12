//
//  Coordinator.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation
import SwiftUI
import UIKit

protocol StationsCoordinating {
    func prepareStationsListView() -> StationListsView
    func prepareStationDetailsView() -> StationDetailsView
}

protocol Coordinating: StationsCoordinating {}

/// Coordinator to create necessary components for production and inject necessary dependencies.
final class Coordinator: Coordinating {
    
    // MARK: - Mappers and Formatters
    lazy var stationsStateMapper: StationsListStateMapping = StationsListStateMapper()
    lazy var distanceFormatter = DistanceFormatter()

    // MARK: - Services
    lazy var netwrokService: NetworkService = .init(config:
            .init(
                baseUrl: URL(string: "https://api.tfl.gov.uk")!,
                headers: [:]
            )
    )
    lazy var persistanceStore: BikePointPersisting = BikePointStore()
    lazy var locationService: Locating = LocationService()
    
    lazy var bikePointApi: BikePointFetching = BikePointApi(
        networkService: netwrokService,
        store: persistanceStore
    )
    
    // MARK: - Navigation
    lazy var navigationController: UINavigationController = UINavigationController()

    lazy var stationsNavigator: StationsNavigating = StationsNavigator(
        navigation: navigationController,
        detailsPresenterResolver: {[unowned self] in self.detailsPresenter },
        detailsViewResolver: {[unowned self] in self.prepareStationDetailsView() }
    )
    
    // MARK: - Presenters
    lazy var stationsPresenter: StationsListPresenter = .init(
        bikePointService: bikePointApi,
        locationService: locationService,
        mapper: stationsStateMapper,
        navigator: stationsNavigator,
        distanceFormatter: distanceFormatter
    )
    
    lazy var detailsPresenter: StationDetailsPresenter = .init(
        navigator: stationsNavigator,
        locationService: locationService,
        distanceFormatter: distanceFormatter
    )
    
    // MARK: - Views
    
    func prepareStationsListView() -> StationListsView {
        StationListsView(state: stationsPresenter.listState)
    }
    
    func prepareStationDetailsView() -> StationDetailsView {
        StationDetailsView(state: detailsPresenter.state)
    }
    
    func prepareStationsMapView() -> StationsMapView<StationListsView> {
        StationsMapView(state: self.stationsPresenter.markersState) { self.prepareStationsListView() }
    }
    
    func prepareStationsNavigationView() -> CustomNavigationView {
        navigationController.push(view: prepareStationsMapView())
        navigationController.navigationBar.isHidden = true
        return CustomNavigationView(navigationController: navigationController)
    }
}
