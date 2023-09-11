//
//  LocationService.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation
import CoreLocation
import Combine

typealias Coordinate = CLLocationCoordinate2D

/// Public subscription interface to overcome limitations that published properties not allowed in protocol
final class LocationState: ObservableObject {
    @Published var location: Coordinate?
}

protocol Locating {
    var state: LocationState { get }
    func start()
    func stop()
    func distance(from coordinatesA: Coordinate, to coordinatesB: Coordinate) -> Double
}

final class LocationService: NSObject, CLLocationManagerDelegate, Locating {

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    // MARK: - Public
    lazy var state: LocationState = LocationState()
    
    func distance(from coordinatesA: Coordinate, to coordinatesB: Coordinate) -> Double {
        let locationA = CLLocation(latitude: coordinatesA.latitude, longitude: coordinatesA.longitude)
        let locationB = CLLocation(latitude: coordinatesB.latitude, longitude: coordinatesB.longitude)

        return locationB.distance(from: locationA)
    }
        
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case  .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default: break
        }
    }
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        locations.forEach { location in
            state.location = location.coordinate
        }
    }
}
