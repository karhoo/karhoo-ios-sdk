//
//  LoyaltyBurnMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  Created by Edward Wilkins on 18/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class LoyaltyBurnMethodSpec: XCTestCase {

    private var loyaltyService: LoyaltyService!
    private let path = "/v1/loyalty-someid/exrates/EUR/burnpoints?amount=10000"
    private var call: Call<LoyaltyPoints>!

    override func setUp() {
        super.setUp()

        loyaltyService = Karhoo.getLoyaltyService()
        call = loyaltyService.getLoyaltyBurn(identifier: "id", currency: "EUR", amount: 10000)
    }

    /**
      * Given: Requesting a loyalty balance
      * When: Request succeeds with burnable true
      * Then: Success result should be propogated
      */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "LoyaltyPoints.json", path: path)

        let expectation = self.expectation(description: "Calls callback with success result")
        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            XCTAssertEqual(100, result.successValue()?.points)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Requesting a loyalty balance
     * When: Request fails with error
     * Then: error type should be propogated
     */
    func testErrorResponse() {
        NetworkStub.errorResponse(path: self.path, responseData: RawKarhooErrorFactory.buildError(code: "K0001"))

        let expectation = self.expectation(description: "Calls callback with error result")
        call.execute(callback: { result in
            XCTAssertEqual(.generalRequestError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Requesting a loyalty balance
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
     * Given: Requesting a loyalty balance
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

