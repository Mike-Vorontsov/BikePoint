//
//  StationDetailsPresenter.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation

protocol StationDetailsPresenting {
    var state: StationDetailsState { get }
}

final class StationDetailsPresenter: StationDetailsPresenting {
  
    private let detailsFetching: BikePointFetching
    
    init(detailsFetching: BikePointFetching) {
        self.detailsFetching = detailsFetching
        start()
    }
    
    lazy var state: StationDetailsState = .init(name: "", distance: "", address: "")
    
    var selectedBikePoint: BikePoint? {
        didSet {
            guard let selectedBikePoint else { return }
            state.name = selectedBikePoint.address
        }
    }
    
    func start() {
        
    }
    
    
    
}
