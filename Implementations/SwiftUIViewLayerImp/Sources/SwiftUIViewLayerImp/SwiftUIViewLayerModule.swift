//
//  SwiftUIViewLayerModule.swift
//
//
//  Created by Mykhailo Vorontsov on 11/09/2024.
//

import ViewLayerInterface
import SwiftUI

public final class SwiftUIViewLayerModule {
    private init() {}
    
    public static var share: SwiftUIViewLayerModule = .init()
    
    public func prepareStationDetailsView(state: StationDetailsState) -> Navigatable {
        AnyView(StationDetailsView(state: state))
    }
    
    public func prepareStationsMapView(mapState: StationsMapState, listState: StationsListState) -> Navigatable {
        AnyView(
            StationsMapView(state: mapState) { StationListsView(state: listState) }
        )
    }
    
    private lazy var navigator: CustomNavigationView = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        return CustomNavigationView(navigationController: navigationController)
    }()
    
    public func prepareNavigator() -> Navigating {
        navigator
    }
    
    public func prepareRootView(startingView: Navigatable) -> AnyView {
        navigator.push(view: startingView)
        return AnyView(navigator)
    }
}
