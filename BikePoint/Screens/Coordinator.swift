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

final class Coordinator: Coordinating {
    
    lazy var netwrokService: NetworkService = .init(config:
            .init(
                baseUrl: URL(string: "https://api.tfl.gov.uk")!,
                headers: [:]
            )
    )
    
    lazy var stationsStateMapper: StationsListStateMapping = StationsListStateMapper()
    
    lazy var locationService: Locating = LocationService()
    
    lazy var stationsPresenter: StationsListPresenter = .init(
        bikePointService: BikePointApi(networkService: netwrokService),
        locationService: locationService,
        mapper: stationsStateMapper,
        navigator: stationsNavigator
    )
    
    lazy var detailsPresenter: StationDetailsPresenter = .init(detailsFetching: BikePointApi(networkService: netwrokService))
    
    lazy var navigationController: UINavigationController = UINavigationController()
    
    lazy var stationsNavigator: StationsNavigating = StationsNavigator(
        navigator: navigationController,
        coordinator: self,
        detailsPresenter: detailsPresenter
    )
    
    func prepareStationsListView() -> StationListsView {
        StationListsView(state: stationsPresenter.state)
    }
    
    func prepareStationDetailsView() -> StationDetailsView {
        StationDetailsView(state: detailsPresenter.state)
    }
    
    func prepareSationsMapView() -> StationsMapView<StationListsView> {
        StationsMapView(
            state: self.stationsPresenter.markersState,
            content: {
                self.prepareStationsListView()
            }
        )
    }
    
    func prepareStationsNavigationView() -> CustomNavigationView {
        let view = CustomNavigationView(navigationController: navigationController)
//        navigationController.push(view: prepareStationsListView())
        navigationController.push(view: prepareSationsMapView())
        return view
    }
    
    func prepareRootView() -> RootView {
        RootView(coordinator: self)
    }
}
