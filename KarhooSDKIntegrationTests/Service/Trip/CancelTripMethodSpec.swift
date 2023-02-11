//
//  CancelTripMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class CancelTripMethodSpec: XCTestCase {

    private var tripService: TripService!
    private let path = "/v1/bookings/some/cancel"
    private var call: Call<KarhooVoid>!

    override func setUp() {
        super.setUp()

        tripService = Karhoo.getTripService()

        let tripCancellation = TripCancellation(tripId: "some",
                                                cancelReason: .notNeededAnymore)

        call = tripService.cancel(tripCancellation: tripCancellation)
    }

    /**
      * Given: Cancelling a trip
      * When: Request succeeds
      * Then: Success result should be propogated
      */
    func testHappyPath() {
        NetworkStub.emptySuccessResponse(path: path)

        let expectation = self.expectation(description: "Calls callback with success result")
        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Cancelling a trip
     * When: Request fails with error
     * Then: error type should be propogated
     */
    func testErrorResponse() {
        NetworkStub.errorResponse(path: self.path, responseData: RawKarhooErrorFactory.buildError(code: "K4007"))

        let expectation = self.expectation(description: "Calls callback with error result")
        call.execute(callback: { result in
            XCTAssertEqual(.couldNotCancelTrip, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Cancelling a trip
     * When: Request fails with error that is invalid
     * Then: unkown error type should be propogated
     */
    func testErrorInvalidResponse() {
        NetworkStub.responseWithInvalidData(path: self.path, statusCode: 400)

        let expectation = self.expectation(description: "Calls callback with error result")
        call.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Cancelling a trip
     * When: Request times out
     * Then: Unknown error should be propogated
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: path)

        let expectation = self.expectation(description: "Unknown error propogated")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }
}
