//
//  PositionExtSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK
import CoreLocation

class PositionExtSpec: XCTestCase {

    /**
      * When: Lat and long are 0
      * Then: isValid should return false
      */
    func testInvalidLatLong() {
        let invalidLatLong = Position(latitude: 0.0, longitude: 0.0)
        XCTAssertFalse(invalidLatLong.isValid())
    }

    /**
      * When: latitude is 0 but longitude is not 0
      * Then: isValid should return true
      */
    func testZeroLongNonZeroLat() {
        let validLatLong = Position(latitude: 0.0, longitude: 10)
        XCTAssertTrue(validLatLong.isValid())
    }

    /**
     * When: latitude is not 0 but longitude
     * Then: isValid should return true
     */
    func testZeroLatNonZeroLong() {
        let validLatLong = Position(latitude: 10.0, longitude: 0)
        XCTAssertTrue(validLatLong.isValid())
    }

    /**
     * When: latitude is not 0 but longitude
     * Then: isValid should return true
     */
    func testValidLatLong() {
        let validLatLong = Position(latitude: 15, longitude: 15)
        XCTAssertTrue(validLatLong.isValid())
    }

    /**
      * When: Converting a position to a CLLocation
      * Then: The expected CLLocation should be returned
      */
    func testToCLLocation() {
        let position = Position(latitude: 10, longitude: 20)

        let convertedPosition = position.toCLLocation()

        XCTAssertEqual(10, convertedPosition.coordinate.latitude)
        XCTAssertEqual(20, convertedPosition.coordinate.longitude)
    }
}
