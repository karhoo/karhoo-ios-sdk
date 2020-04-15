//
//  KarhooDriverTrackingServiceSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

import XCTest

@testable import KarhooSDK

final class KarhooDriverTrackingServiceSpec: XCTestCase {

    private var testObject: KarhooDriverTrackingService!

    override func setUp() {
        super.setUp()

        testObject = KarhooDriverTrackingService()
    }

    /**
     * When: Tracking a driver
     * Then: KarhooPollableCall<DriverTrackingInteractor> should be returned
     */
    func testTrackDriver() {
        let pollCall = testObject.trackDriver(tripId: "some")
        XCTAssertNotNil(pollCall)
    }
}
