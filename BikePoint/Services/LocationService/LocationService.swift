//
//  LocationService.swift
//  BikePoint
//
//  Created by Mykhailo Vorontsov on 07/09/2023.
//

import Foundation
import CoreLocation

protocol Subscribing {
    func store(in collection: inout Array<Any>)
}

extension Subscribing {
    func store(in collection: inout Array<Any>) {
        collection.append(self)
    }
}

typealias Coordinate = CLLocationCoordinate2D

final class SubscribeToken: Subscribing {
    private var unsubscibeHandler: (() -> ())
    
    init(unsubscribe: @escaping (() -> ())) {
        self.unsubscibeHandler = unsubscribe
    }
    
    deinit {
        self.unsubscibeHandler()
    }
}

protocol Locating {
    
    @discardableResult
    func subscribe(eventHandler: @escaping (Coordinate) -> ()) -> any Subscribing
    
    func distance(from coordinatesA: Coordinate, to coordinatesB: Coordinate) -> Double
}

final class LocationService: NSObject, CLLocationManagerDelegate, Locating {
    
    typealias EventHandler = (Coordinate) -> ()
    
    private typealias Token = UUID
    private typealias Subscription = (handler: EventHandler, token: Token)

    private var subscriptions: [Subscription] = []
    
    var latestLocation: Coordinate?

    func distance(from coordinatesA: Coordinate, to coordinatesB: Coordinate) -> Double {
        let locationA = CLLocation(latitude: coordinatesA.latitude, longitude: coordinatesA.longitude)
        let locationB = CLLocation(latitude: coordinatesB.latitude, longitude: coordinatesB.longitude)

        return locationB.distance(from: locationA)
    }
    
    @discardableResult
    func subscribe(eventHandler: @escaping EventHandler) -> any Subscribing {
        let uuid = UUID()
        let token = SubscribeToken { [weak self] in
            self?.subscriptions.removeAll { $0.1 == uuid }
            
            if self?.subscriptions.count == 0 {
                self?.locationManager.stopUpdatingLocation()
            }
        }
        
        subscriptions.append((eventHandler, uuid))
//        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let latestLocation {
            post(coordinate: latestLocation)
        }
        
        return token
    }
        
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case  .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default: break
        }
        
//        if status == .authorizedAlways {
//            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
//                if CLLocationManager.isRangingAvailable() {
//                    // do stuff
//                }
//            }
//        }
    }
    
    private func post(coordinate: CLLocationCoordinate2D) {
        subscriptions.forEach { subscription  in
            subscription.handler(coordinate)
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        locations.forEach { location in
            latestLocation = location.coordinate
            post(coordinate: location.coordinate)
        }
    }
}
