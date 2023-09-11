//
//  StationDetailsPresenter.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation

protocol StationDetailsPresenting: AnyObject {
    var selectedBikePoint: BikePoint? { get set }
    var state: StationDetailsState { get }
}

final class StationDetailsPresenter: StationDetailsPresenting {
  
    private let detailsFetching: BikePointFetching
    private let navigator: StationsNavigating
    
    init(navigator: StationsNavigating, detailsFetching: BikePointFetching) {
        self.navigator = navigator
        self.detailsFetching = detailsFetching
        start()
    }
    
    lazy var state: StationDetailsState = .init(
        name: "", 
        distance: "",
        address: "",
        coordinates: .init(latitude: 0, longitude: 0)
    ) { [weak self] in
        self?.navigator.dismissDetails()
    }
    
    var selectedBikePoint: BikePoint? {
        didSet {
            guard let selectedBikePoint else { return }
            state.name = selectedBikePoint.address
            state.coordinates = selectedBikePoint.location
        }
    }
    
    func start() {
        
    }
}
