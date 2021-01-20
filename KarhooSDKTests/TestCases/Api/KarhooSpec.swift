//
//  KarhooSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

class KarhooSpec: XCTestCase {

    /**
     *  When:   Setting an SDKConfiguration implementation
     *  Then:   Shared settings should be set
     */
    func testSettingAConfiguration() {
        Karhoo.set(configuration: MockSDKConfig())

        let configSet = Karhoo.configuration

        if case KarhooEnvironment.sandbox = configSet!.environment() {} else {
            XCTFail("Environment not configured")
        }
    }

    /**
     *  When:   Getting a login service
     *  Then:   It should return a KarhooUserService
     */
    func testGetUserService() {
        let userService = Karhoo.getUserService()

        XCTAssertNotNil(userService as? KarhooUserService)
    }

    /**
     *  When:   Getting an address service
     *  Then:   It should return an instance of KarhooAddressService
     */
    func testGetAddressService() {
        let addressService = Karhoo.getAddressService()

        XCTAssertNotNil(addressService as? KarhooAddressService)
    }

    /**
     *  When:   Getting an address service
     *  Then:   It should return an instance of KarhooQuoteService
     */
    func testGetQuoteService() {
        let quoteService = Karhoo.getQuoteService()

        XCTAssertNotNil(quoteService as? KarhooQuoteService)
    }

    /**
     *  When:   Getting an analytics service
     *  Then:   It should return an instance of KarhooAnalyticsService
     */
    func testGetAnalyticsService() {
        let analytics = Karhoo.getAnalyticsService()

        XCTAssertNotNil(analytics as? KarhooAnalyticsService)
    }

    /**
     *  When:   Getting a payment service
     *  Then:   It should return an instance of KarhooPaymentService
     */
    func testGetPaymentService() {
        let paymentService = Karhoo.getPaymentService()

        XCTAssertNotNil(paymentService as? KarhooPaymentService)
    }

    /**
     *  When:   Getting a driver tracking service
     *  Then:   It should return an instance of KarhooDriverTrackingService
     */
    func testGetDriverTrackingService() {
        let driverTrackingService = Karhoo.getDriverTrackingService()

        XCTAssertNotNil(driverTrackingService as? KarhooDriverTrackingService)
    }

    /**
     *  When:   Getting a booking status
     *  Then:   It should return an instance of KarhooBookingStatus
     */
    func testGetBroadcaster() {
        let broadcaster = Karhoo.Utils.getBroadcaster(ofType: AnyObject.self)

        XCTAssertNotNil(broadcaster)
    }

    /**
     *  When:   Getting a fare  service
     *  Then:   It should return an instance of fare service
     */
    func testGetFareService() {
        let fareService = Karhoo.getFareService()
        XCTAssertNotNil(fareService)
    }

    /**
     *  When:   Getting an auth  service
     *  Then:   It should return an instance of auth service
     */
    func testGetAuthService() {
        let authService = Karhoo.getAuthService()
        XCTAssertNotNil(authService)
    }
    
    /**
     *  When:   Getting a loyalty service
     *  Then:   It should return an instance of  loyalty service
     */
    func testGetLoyaltyService() {
        let loyaltyService = Karhoo.getLoyaltyService()
        XCTAssertNotNil(loyaltyService)
    }

    /**
     *  Given:  Trip service has been requested
     *  When:   Asking for trip service again
     *  Then:   Same object should be return (to ensure we don't have multiple trip/location broadcaster managers)
     */
    func testMultipleTripService() {
        let firstTripService = Karhoo.getTripService() as? KarhooTripService
        let secondTripService = Karhoo.getTripService() as? KarhooTripService

        XCTAssert(firstTripService === secondTripService)
    }
}
