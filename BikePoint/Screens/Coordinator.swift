//
//  Coordinator.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation
import SwiftUI

protocol StationsCoordinating {
    func prepareStationsListView() -> StationListsView
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
    
    lazy var stationsPresenter: StationsListPresenter = .init(
        service: netwrokService,
        mapper: stationsStateMapper
    )
    
    func prepareStationsListView() -> StationListsView {
        StationListsView(state: stationsPresenter.state)
    }
}
