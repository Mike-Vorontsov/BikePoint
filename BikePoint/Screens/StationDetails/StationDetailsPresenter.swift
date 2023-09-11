//
//  StationDetailsPresenter.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation
import Combine

protocol StationDetailsPresenting: AnyObject {
    var selectedBikePoint: BikePoint? { get set }
    var state: StationDetailsState { get }
}

final class StationDetailsPresenter: StationDetailsPresenting {
    
    private let navigator: StationsNavigating
    private let detailsFetching: BikePointFetching
    private let locationService: Locating
    private let distanceFormatter: DistanceFormatter
    
    private var discardBag: [AnyCancellable] = []
    
    init(navigator: StationsNavigating, detailsFetching: BikePointFetching, locationService: Locating, distanceFormatter: DistanceFormatter) {
        self.navigator = navigator
        self.detailsFetching = detailsFetching
        self.locationService = locationService
        self.distanceFormatter = distanceFormatter
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

            if let location = locationService.state.location {
                let distance = self.locationService.distance(from: selectedBikePoint.location, to: location)
                state.distance = distanceFormatter.string(for: distance)
            }

            
            Task {
                let geocode = try await locationService.geocode(for: selectedBikePoint.location)
                
                await MainActor.run {
                    state.address = geocode ?? ""
                }
            }
        }
    }
    
    func start() {
        locationService.state
            .$location
            .compactMap { [weak self] currentLocation -> String? in
                guard
                    let self,
                    let currentLocation,
                    let selectedBikePoint = self.selectedBikePoint
                else { return  nil }
                
                let distance = self.locationService.distance(from: selectedBikePoint.location, to: currentLocation)
                return distanceFormatter.string(for: distance)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.distance, on: state)
            .store(in: &discardBag)
        
    }
    
}

