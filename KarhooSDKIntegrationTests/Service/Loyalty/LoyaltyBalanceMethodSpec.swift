//
//  LoyaltyBalanceMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  Created by Nurseda Balcioglu on 18/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class LoyaltyBalanceMethodSpec: XCTestCase {

    private var loyaltyService: LoyaltyService!
    private let path = "/v3/payments/loyalty/programmes/id/balance"
    private var call: Call<LoyaltyBalance>!

    override func setUp() {
        super.setUp()

        loyaltyService = Karhoo.getLoyaltyService()
        call = loyaltyService.getLoyaltyBalance(identifier: "id")
    }

    /**
      * Given: Requesting a loyalty balance
      * When: Request succeeds with burnable true
      * Then: Success result should be propogated
      */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "LoyaltyBalanceTrue.json", path: path)

        let expectation = self.expectation(description: "Calls callback with success result")
        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            XCTAssertEqual(true, result.successValue()?.burnable)
            XCTAssertEqual(10, result.successValue()?.points)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
    
    /**
      * Given: Requesting a loyalty balance
      * When: Request succeeds with burnable false
      * Then: Success result should be propogated as false
      */
    func testHappyPathCancellationFeeFalse() {
        NetworkStub.successResponse(jsonFile: "LoyaltyBalanceFalse.json", path: path)

        let expectation = self.expectation(description: "Calls callback with success result")
        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            XCTAssertEqual(false, result.successValue()?.burnable)
            XCTAssertEqual(10, result.successValue()?.points)
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
