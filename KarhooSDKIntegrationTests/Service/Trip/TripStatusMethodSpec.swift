//
//  TripStatusMethod.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class TripStatusMethodSpec: XCTestCase {

    private var tripService: TripService!
    private let path = "/v1/bookings/some/status"
    private var pollCall: PollCall<TripState>!

    override func setUp() {
        super.setUp()

        tripService = Karhoo.getTripService()
        pollCall = tripService.status(tripId: "some")
    }

    /**
     * When: Getting trip status
     * And: The result succeeds
     * Then: Expected result should be propogated
     */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "TripStatus.json", path: path)
        let expectation = self.expectation(description: "Calls callback with success result")

        pollCall.execute(callback: { result in
            XCTAssertEqual(.passengerOnBoard, result.successValue())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * When: Getting trip status
     * And: The result succeeds but the response is empty
     * Then: Trip status should be unkown
     */
    func testSuccessEmptyResponse() {
        NetworkStub.emptySuccessResponse(path: path)

        let expectation = self.expectation(description: "Calls callback with unknown trip state")

        pollCall.execute(callback: { result in
            XCTAssertEqual(.unknown, result.successValue())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * When: Getting trip status
     * And: The result succeeds but the response is invalid
     * Then: Trip status should be unkown
     */
    func testSuccessInvalidResponse() {
        NetworkStub.responseWithInvalidData(path: path, statusCode: 200)

        let expectation = self.expectation(description: "Calls callback with unknown trip state")

        pollCall.execute(callback: { result in
            XCTAssertEqual(.unknown, result.successValue())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * When: Getting trip status
     * And: The result fails with valid error
     * Then: Expected error should be propogated
     */
    func testErrorResponse() {
        NetworkStub.errorResponse(path: path, responseData: RawKarhooErrorFactory.buildError(code: "K4011"))

        let expectation = self.expectation(description: "Calls callback with expected error")

        pollCall.execute(callback: { result in
            XCTAssertEqual(.couldNotGetTrip, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * When: Getting trip status
     * And: The result fails with an invalid error
     * Then: unknown error should be propogated
     */
    func testErrorInvalidResponse() {
        NetworkStub.responseWithInvalidData(path: path, statusCode: 400)

        let expectation = self.expectation(description: "Calls callback with unknown error")

        pollCall.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Polling for trip status
     * When: The request succeeds
     * And: Then the request fails
     * Then: Two results should be propogated as expected
     */
    func testTripStatusPolling() {
        NetworkStub.successResponse(jsonFile: "TripStatus.json", path: path)

        var tripStatusResult: [Result<TripState>] = []
        let expectation = self.expectation(description: "polling returns 2 times")
        let observer = Observer { (result: Result<TripState>) in
            tripStatusResult.append(result)
            NetworkStub.errorResponse(path: self.path,
                                      responseData: RawKarhooErrorFactory.buildError(code: "K4012"))

            if tripStatusResult.count == 2 {
                XCTAssertEqual(.passengerOnBoard, tripStatusResult[0].successValue())
                XCTAssertEqual(.couldNotGetTripCouldNotFindSpecifiedTrip, tripStatusResult[1].errorValue()?.type)
                expectation.fulfill()
            }
        }
        pollCall.observable(pollTime: 0.3).subscribe(observer: observer)
        waitForExpectations(timeout: 10)
    }
}
