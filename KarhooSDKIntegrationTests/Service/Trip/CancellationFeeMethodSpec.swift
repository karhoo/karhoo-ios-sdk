//
//  CancellationFeeMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  Created by Nurseda Balcioglu on 03/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class CancellationFeeMethodSpec: XCTestCase {

    private var tripService: TripService!
    private let path = "/v1/bookings/id/cancel-fee"
    private var call: Call<CancellationFee>!

    override func setUp() {
        super.setUp()

        tripService = Karhoo.getTripService()
        call = tripService.cancellationFee(identifier: "id")
    }

    /**
      * Given: Requesting a cancellation fee
      * When: Request succeeds
      * Then: Success result should be propogated
      */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "CancellationFee.json", path: path)

        let expectation = self.expectation(description: "Calls callback with success result")
        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            XCTAssertEqual(true, result.successValue()?.cancellationFee)
            XCTAssertEqual(100, result.successValue()?.fee.value)
            XCTAssertEqual(1.00, result.successValue()?.fee.decimalValue)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
    
    /**
      * Given: Requesting a cancellation fee
      * When: Request succeeds
      * Then: Success result should be propogated as false
      */
    func testHappyPathCancellationFeeFalse() {
        NetworkStub.successResponse(jsonFile: "CancellationFeeFalse.json", path: path)

        let expectation = self.expectation(description: "Calls callback with success result")
        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            XCTAssertEqual(false, result.successValue()?.cancellationFee)
            XCTAssertEqual(0, result.successValue()?.fee.value)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Requesting a cancellation fee
     * When: Request fails with error
     * Then: error type should be propogated
     */
    func testErrorResponse() {
        NetworkStub.errorResponse(path: self.path, responseData: RawKarhooErrorFactory.buildError(code: "K4007"))

        let expectation = self.expectation(description: "Calls callback with error result")
        call.execute(callback: { result in
            XCTAssertEqual(.couldNotCancelTrip, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Requesting a cancellation fee
     * When: Request fails with error that is invalid
     * Then: unkown error type should be propogated
     */
    func testErrorInvalidResponse() {
        NetworkStub.responseWithInvalidData(path: self.path, statusCode: 400)

        let expectation = self.expectation(description: "Calls callback with error result")
        call.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Requesting a cancellation fee
     * When: Request times out
     * Then: Unknown error should be propogated
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: path)

        let expectation = self.expectation(description: "Unknown error propogated")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
}
