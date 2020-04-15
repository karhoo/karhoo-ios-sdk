//
//  GetFareSpec.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

//swiftlint:disable
//function_body_length

import XCTest
@testable import KarhooSDK

final class FareMethodSpec: XCTestCase {

    private var fareService: FareService!
    private let tripId = "123"
    private var path: String! 
    private var call: Call<Fare>!
    
    override func setUp() {
        super.setUp()
        
        fareService = Karhoo.getFareService()
        path = "/v1/fares/trip/" + tripId
        call = fareService.fareDetails(tripId: tripId)
    }
    
    /**
        * When: Requesting a fare for a specific trip
        * And: The result succeeds
        * Then: Expected result should be propogated
    */
    func testGetFareSuccess() {
        NetworkStub.response(fromFile: "Fare.json", forPath: path, statusCode: 200)
        
        let expectation = self.expectation(description: "calls the callback with success")
        
        call.execute(callback: { result in
            self.assertSuccess(result: result)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1)
    }
    
    private func assertSuccess(result: Result<Fare>) {
        XCTAssert(result.isSuccess())
        guard let fare = result.successValue() else {
            XCTFail("Missing success value")
            return
        }
        
        XCTAssertEqual(fare.state, "PENDING")
        XCTAssertEqual(fare.expectedFinalTime, "2016-04-16T16:06:05Z")
        XCTAssertEqual(fare.expectedIn, "360")
        XCTAssertEqual(fare.breakdown.total, 0)
        XCTAssertEqual(fare.breakdown.currency, "EUR")
    }
    
    /**
     * When: Requesting a fare
     * And: The result fails
     * Then: Expected error should be propogated
     */
    func testGetFareFails() {
        let trackTripError = RawKarhooErrorFactory.buildError(code: "K4001")

        NetworkStub.errorResponse(path: path, responseData: trackTripError)

        let expectation = self.expectation(description: "calls callback with error result")

        call.execute(callback: { result in
            XCTAssertEqual(.couldNotBookTrip, result.errorValue()!.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
    
    /**
     * When: Get a fare
     * And: The response returns empty json object
     * Then: Result is success with empty TripInfo object
     */
    func testEmptyResponse() {
        NetworkStub.emptySuccessResponse(path: path)

        let expectation = self.expectation(description: "calls the callback with success")

        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
    
    /**
     * When: Get a fare
     * And: The response returns invalid json object
     * Then: Result is error
     */
    func testInvalidResponse() {
        NetworkStub.responseWithInvalidJson(path: path, statusCode: 200)

        let expectation = self.expectation(description: "calls the callback with error")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
    
    /**
     * When: Get a fare
     * And: The response returns time out error
     * Then: Result is error
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: path)

        let expectation = self.expectation(description: "calls the callback with error")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
}
