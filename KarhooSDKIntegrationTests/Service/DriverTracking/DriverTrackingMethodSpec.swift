//
//  DriverTrackingMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class DriverTrackingMethodSpec: XCTestCase {

    private var driverTrackingService: DriverTrackingService!
    private let path = "/v1/bookings/some/track"
    private var pollCall: PollCall<DriverTrackingInfo>!

    override func setUp() {
        super.setUp()

        driverTrackingService = Karhoo.getDriverTrackingService()

        pollCall = driverTrackingService.trackDriver(tripId: "some")
    }

    /**
      * When: Getting a driver position
      * And: The result succeeds
      * Then: Expected result should be propogated
      */
    func testExecuteDriverTrackingSuccess() {
        NetworkStub.response(fromFile: "DriverTracking.json", forPath: path, statusCode: 200)

        let expectation = self.expectation(description: "calls the callback with success")

        pollCall.execute(callback: { result in
            self.assertSuccess(result: result)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * When: Getting a driver position
     * And: The result fails
     * Then: Expected error should be propogated
     */
    func testExecuteDriverTrackingFails() {
        let driverTrackingError = RawKarhooErrorFactory.buildError(code: "K4012")

        NetworkStub.errorResponse(path: path, responseData: driverTrackingError)

        let expectation = self.expectation(description: "Calls callback with K4012 error type")

        pollCall.execute(callback: { result in
            XCTAssertEqual(.couldNotGetTripCouldNotFindSpecifiedTrip, result.getErrorValue()!.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
      * Given: Polling for a driver position
      * When: The request succeeds
      * And: Then the request fails
      * Then: Two results should be propogated as expected
      */
    func testDriverTrackingPolling() {
        NetworkStub.response(fromFile: "DriverTracking.json", forPath: path, statusCode: 200)

        var driverTrackingResults: [Result<DriverTrackingInfo>] = []
        let expectation = self.expectation(description: "polling returns 2 times")
        let observer = Observer { (result: Result<DriverTrackingInfo>) in
            driverTrackingResults.append(result)
            NetworkStub.errorResponse(path: self.path,
                                      responseData: RawKarhooErrorFactory.buildError(code: "K4012"))

            if driverTrackingResults.count == 2 {
                self.assertSuccess(result: driverTrackingResults[0])
                XCTAssertEqual(.couldNotGetTripCouldNotFindSpecifiedTrip, driverTrackingResults[1].getErrorValue()?.type)
                expectation.fulfill()
            }
        }
        pollCall.observable(pollTime: 1).subscribe(observer: observer)
        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Getting a driver position
     * When: Request times out
     * Then: Unknown error should be propogated
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: path)

        let expectation = self.expectation(description: "Unknown error propogated")
        pollCall.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    private func assertSuccess(result: Result<DriverTrackingInfo>) {
        XCTAssertEqual(Position(latitude: 1, longitude: -1), result.getSuccessValue()?.position)
        XCTAssertEqual(5, result.getSuccessValue()?.originEta)
        XCTAssertEqual(10, result.getSuccessValue()?.destinationEta)
    }
}
