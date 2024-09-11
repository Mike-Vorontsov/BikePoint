//
//  BikePointFeatureModule.swift
//  
//
//  Created by Mykhailo Vorontsov on 11/09/2024.
//

import BikePointApiInterface
import LocationServiceInterface
import ViewLayerInterface

public class BikePointFeatureModule {
    
    private init() {}
    
    public static let shared: BikePointFeatureModule = {
        .init()
    }()
    
    // MARK: - Mappers and Formatters
    private lazy var stationsStateMapper: StationsListStateMapping = StationsListStateMapper()
    private lazy var distanceFormatter = DistanceFormatter()
    
    // MARK: - Public interfaces
    public func prepareNavigator(
        navigation: Navigating,
        detailsPresenterResolver: @escaping (() -> (StationDetailsPresenting)),
        detailsViewResolver: @escaping (() -> (Navigatable))
    ) -> StationsNavigating {
        StationsNavigator(
            navigation: navigation,
            detailsPresenterResolver: detailsPresenterResolver,
            detailsViewResolver: detailsViewResolver
        )
    }
    
    public func prepareStationListPresenter(
        bikePointService: BikePointFetching,
        locationService: Locating,
        navigator: StationsNavigating
    ) -> StationsListPresenting {
        StationsListPresenter(
            bikePointService: bikePointService,
            locationService: locationService,
            mapper: stationsStateMapper,
            navigator: navigator,
            distanceFormatter: distanceFormatter
        )
    }
    
    public func prepareStationDetailsPresenter(
        navigator: StationsNavigating,
        locationService: Locating
    ) -> StationDetailsPresenting {
        StationDetailsPresenter(
            navigator: navigator,
            locationService: locationService,
            distanceFormatter: distanceFormatter
        )
    }
    
}

