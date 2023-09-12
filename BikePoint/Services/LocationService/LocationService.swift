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

/// Typealias to use Coordinates along the app without referring to CoreLocation
typealias Coordinates = CLLocationCoordinate2D

/// Public subscription interface to overcome limitations that published properties not allowed in protocol
final class LocationState: ObservableObject {
    @Published var location: Coordinates?
}

/// Protocol describing interface for LocationService
protocol Locating {
    ///  State of current location. Can be used for subscribing for current location
    var state: LocationState { get }
    
    
    /// Start location tracking
    func start()
    
    /// Stop location tracking
    func stop()
    
    /// Calculate distance between to coordinates, in meters
    func distance(from coordinatesA: Coordinates, to coordinatesB: Coordinates) -> Double
    
    /// Calculate nearest postal address to specific coordinates, format it to a single line string.
    func address(for coordinates: Coordinates) async throws -> String?
}

/// Service to determine current location
final class LocationService: NSObject, CLLocationManagerDelegate, Locating {

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
    lazy var state: LocationState = LocationState()
    
    func distance(from coordinatesA: Coordinates, to coordinatesB: Coordinates) -> Double {
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
    
    func address(for coordinates: Coordinates) async throws -> String? {
        let placemarks = try await geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude))
        
        guard let postalAddress = placemarks.first?.postalAddress else {
            return "Can't find address"
        }
        let fullAddress = postAddressFormatter.string(from: postalAddress)
        return fullAddress.replacingOccurrences(of: "\n", with: " ")
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

protocol CLLocationManaging {
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

extension CLLocationManager: CLLocationManaging {}
