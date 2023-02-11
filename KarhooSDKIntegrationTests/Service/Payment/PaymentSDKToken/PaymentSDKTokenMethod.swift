//
//  PaymentSDKTokenMethod.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class PaymentSDKTokenMethod: XCTestCase {

    private var paymentService: PaymentService!
    private let path = "/v2/payments/payment-methods/braintree/client-tokens"
    private var call: Call<PaymentSDKToken>!

    override func setUp() {
        super.setUp()

        paymentService = Karhoo.getPaymentService()
        let mockPayload = PaymentSDKTokenPayload(organisationId: "some_org", currency: "GBP")

        call = paymentService.initialisePaymentSDK(paymentSDKTokenPayload: mockPayload)
    }

    /**
      * Given: Calling initialisePaymentSDK
      * When: expected response is returned and a success
      * Then: Expected result should be propogated
      */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "PaymentSDKToken.json", path: self.path)

        let expectation = self.expectation(description: "Callback called with succeess")

        call.execute(callback: { result in
            XCTAssertEqual("some_sdk_token", result.getSuccessValue()?.token)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Calling initialisePaymentSDK
     * When: error returned
     * Then: Expected error should be propogated
     */
    func testErrorResponse() {
        NetworkStub.errorResponse(path: self.path, responseData: RawKarhooErrorFactory.buildError(code: "K0005"))

        let expectation = self.expectation(description: "Callback called with an error")

        call.execute(callback: { result in
            XCTAssertEqual(.missingRequiredRoleForThisRequest, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
      * Given: Calling initialisePaymentSDK
      * When: Response is a http success but contains an empty json
      * Then: Expected error should be propogated
      */
    func testEmptySuccessResponse() {
        NetworkStub.emptySuccessResponse(path: self.path)

        let expectation = self.expectation(description: "callback called with an unexpected error")

        call.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Calling initialisePaymentSDK
     * When: Response is a http success but contains an invalid json
     * Then: Expected error should be propogated
     */
    func testInvalidSuccessResponse() {
        NetworkStub.emptySuccessResponse(path: self.path)

        let expectation = self.expectation(description: "callback called with an unexpected error")

        call.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * When: Calling initialisePaymentSDK
     * And: The response returns time out error
     * Then: Result is error
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: path)

        let expectation = self.expectation(description: "calls the callback with error")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
}
