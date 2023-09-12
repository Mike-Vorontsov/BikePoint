//
//  StationDetailsPresenter.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 08/09/2023.
//

import Foundation
import Combine

/// Protocol describing public interface of StationDetailsPresenter
protocol StationDetailsPresenting: AnyObject {
    /// Selected bike point to be shown
    var selectedBikePoint: BikePoint? { get set }
    
    // State of particular UI
    var state: StationDetailsState { get }
}

/// Presenter for Details screen
final class StationDetailsPresenter: StationDetailsPresenting {
    
    private let navigator: StationsNavigating
    private let locationService: Locating
    private let distanceFormatter: DistanceFormatter
    
    private var discardBag: [AnyCancellable] = []
    
    /// Initialise new Presenter
    /// - Parameters:
    ///   - navigator: navigator for moving between screens on Scenes flow
    ///   - locationService: service for monitoring location
    ///   - distanceFormatter: formatter to format distance to human readable string
    init(navigator: StationsNavigating, locationService: Locating, distanceFormatter: DistanceFormatter) {
        self.navigator = navigator
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
                let geocode = try await locationService.address(for: selectedBikePoint.location)
                
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
