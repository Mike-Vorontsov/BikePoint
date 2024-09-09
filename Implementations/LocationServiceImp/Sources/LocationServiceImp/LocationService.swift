//
//  LocationService.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation
import CoreLocation
import Combine
import Contacts

import Common
import ViewLayerInterface
import LocationServiceInterface

/// Service to determine current location
final public class LocationService: NSObject, CLLocationManagerDelegate, Locating {

    /// Location manager can be (and should be) replaced by wrapper protocol and injected internally, so LocationService can be tested. I used this technic for testing NetworkService. I don't do it here to save time.
    private lazy var locationManager: CLLocationManaging = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    private lazy var geocoder = CLGeocoder()
    private lazy var postAddressFormatter = CNPostalAddressFormatter()

    // MARK: - Public
    public lazy var state: LocationState = LocationState()
    
    public func distance(from coordinatesA: Coordinates, to coordinatesB: Coordinates) -> Double {
        let locationA = CLLocation(latitude: coordinatesA.latitude, longitude: coordinatesA.longitude)
        let locationB = CLLocation(latitude: coordinatesB.latitude, longitude: coordinatesB.longitude)

        return locationB.distance(from: locationA)
    }
    
    public func start() {
        locationManager.startUpdatingLocation()
    }
    
    public func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    public func address(for coordinates: Coordinates) async throws -> String? {
        let placemarks = try await geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude))
        
        guard let postalAddress = placemarks.first?.postalAddress else {
            return "Can't find address"
        }
        let fullAddress = postAddressFormatter.string(from: postalAddress)
        return fullAddress.replacingOccurrences(of: "\n", with: " ")
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case  .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default: break
        }
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        locations.forEach { location in
            state.location = location.coordinate
        }
    }
}

protocol CLLocationManaging {
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

extension CLLocationManager: CLLocationManaging {}
