//
//  GeneralErrorSpec.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK

final class GeneralErrorSpec: XCTestCase {

    // any service
    private var tripService: TripService!
    private let path = "/v1/bookings/123/cancel"
    private var call: Call<KarhooVoid>!

    override func setUp() {
        super.setUp()

        self.tripService = Karhoo.getTripService()
        self.call = tripService.cancel(tripCancellation: TripCancellation(tripId: "123",
                                                                          cancelReason: .notNeededAnymore))
    }

    /**
     * When: Executing a karhoo call
     * And: The response returns an unparsable error
     * Then: Error should be an unkown error type
     */
    func testErrorResponseWithInvalidData() {
        NetworkStub.responseWithInvalidData(path: path, statusCode: 400)

        let expectation = self.expectation(description: "calls the callback with an error")

        call.execute(callback: { result in
            XCTAssertEqual(result.errorValue()?.type, .unknownError)
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 5, handler: .none)
    }

    /**
     * When: Executing a karhoo call
     * And: No internet connection
     * Then: Resulting error value should not be nil
     */
    func testErrorResponseNoInternetConnection() {
        NetworkStub.errorResponseNoNetworkConnection(path: path)

        let expectation = self.expectation(description: "calls the callback with an error")

        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 5, handler: .none)
    }
}
