//
//  UserLocationProviderSpec.swift
//  Karhoo
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import CoreLocation
@testable import KarhooSDK

final class UserLocationProviderSpec: XCTestCase {

    private var mockLocationService: MockCLLocationManager!
    private var testObject: KarhooUserLocationProvider!

    override func setUp() {
        super.setUp()

        mockLocationService = MockCLLocationManager()
        testObject = KarhooUserLocationProvider(locationManager: mockLocationService)
    }

    /**
     *  When    Initialized
     *  Then    The location provider should be correctly configured
     */
    func testSetup() {
        XCTAssert(mockLocationService.desiredAccuracy == kCLLocationAccuracyBest)
        XCTAssert(mockLocationService.activityType == .fitness)
        XCTAssert(mockLocationService.delegate === testObject)
        XCTAssert(mockLocationService.updateLocationStarted)
    }

    /**
     *  When    Getting the last know position
     *  Then    The last known position of the location manager should be returned
     */
    func testGetLastPosition() {
        let location = CLLocation(latitude: 0.1, longitude: 0.1)
        mockLocationService.mockedLocation = location
        let lastKnown = testObject.getLastKnownLocation()

        XCTAssert(lastKnown == location)
    }

    /**
     *  Given   A callback has been set
     *  When    A new location is received
     *  Then    The location should be passed to the callback
     */
    func testCallback() {
        var receivedLocation: CLLocation?
        testObject.set { (location: CLLocation) in
            receivedLocation = location
        }

        let location = CLLocation(latitude: 0.2, longitude: 0.2)
        mockLocationService.triggerUpdate(location: location)

        XCTAssert(receivedLocation == location)
    }

    /**
     *  Given   A callback has been set
     *  When    An empty list of places is received
     *  Then    The location should not be passed to the callback
     */
    func testCallbackNoLocations() {
        var callbackCalled = false
        testObject.set { (_: CLLocation) in
            callbackCalled = true
        }

        mockLocationService.triggerUpdate(location: nil)

        XCTAssert(callbackCalled == false)
    }

    /**
     *  Given   A callback has not been set
     *  When    A new location is received
     *  Then    Nothing should happen
     */
    func testNoCallback() {
        let location = CLLocation(latitude: 0.2, longitude: 0.2)
        mockLocationService.triggerUpdate(location: location)

        // Just make sure nothing crashes
    }
}
