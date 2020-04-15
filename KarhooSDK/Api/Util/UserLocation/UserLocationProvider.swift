//
//  UserLocationProvider.swift
//  Karhoo
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation

public typealias LocationProvidedClosure = (CLLocation) -> Void

public protocol UserLocationProvider {
    func set(locationChangedCallback: LocationProvidedClosure?)
    func getLastKnownLocation() -> CLLocation?
}

public class KarhooUserLocationProvider: NSObject, CLLocationManagerDelegate, UserLocationProvider {
    private let locationManager: CLLocationManager
    private var locationChangedCallback: LocationProvidedClosure?
    public static let shared = KarhooUserLocationProvider()

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()

        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    public func set(locationChangedCallback: LocationProvidedClosure?) {
        self.locationChangedCallback = locationChangedCallback
    }

    public func getLastKnownLocation() -> CLLocation? {
        return self.locationManager.location
    }

    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        locationChangedCallback?(location)
    }
}
