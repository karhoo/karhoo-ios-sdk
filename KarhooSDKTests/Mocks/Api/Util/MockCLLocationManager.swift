//
//  MockCLLocationManager.swift
//  Karhoo
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation

class MockCLLocationManager: CLLocationManager {

    private var _delegate: CLLocationManagerDelegate? // swiftlint:disable:this weak_delegate
    override var delegate: CLLocationManagerDelegate? {
        set {
            _delegate = newValue
        }

        get {
            return _delegate
        }
    }

    var mockedLocation: CLLocation?
    override var location: CLLocation? {
        return mockedLocation
    }

    func triggerUpdate(location: CLLocation?) {
        var locationList = [CLLocation]()
        if let location = location {
            locationList.append(location)
        }
        _delegate?.locationManager?(self, didUpdateLocations: locationList)
    }

    var updateLocationStarted = false
    override func startUpdatingLocation() {
        updateLocationStarted = true
    }

    static var authorizationStatusToReturn: CLAuthorizationStatus = .notDetermined
    override class func authorizationStatus() -> CLAuthorizationStatus {
        return authorizationStatusToReturn
    }

    static var locationEnabledReturnValue: Bool = false
    override class func locationServicesEnabled() -> Bool {
        return locationEnabledReturnValue
    }

    class func reset() {
        locationEnabledReturnValue = false
        authorizationStatusToReturn = .notDetermined
    }

}
