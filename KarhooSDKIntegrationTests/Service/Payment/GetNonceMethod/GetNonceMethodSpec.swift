//
//  GetNonceMethod.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class GetNonceMethodSpec: XCTestCase {

    private var paymentService: PaymentService!
    private let path = "/v2/payments/payment-methods/braintree/get-payment-method"
    private var call: Call<Nonce>!

    override func setUp() {
        super.setUp()

        self.paymentService = Karhoo.getPaymentService()
        let nonceRequestPayload = NonceRequestPayloadMock().set(payer: Payer()).set(organisationId: "some").build()
        self.call = paymentService.getNonce(nonceRequestPayload: nonceRequestPayload)
    }

    /**
     * When: getting nonce
     * And: The response returns a 200 and nonce
     * Then: Result is success
     */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "GetNonce.json", path: path)

        let expectation = self.expectation(description: "calls the callback with expected response")

        call.execute(callback: { result in
            XCTAssertEqual(result.successValue()?.nonce, "some_nonce")
            XCTAssertEqual(result.successValue()?.cardType, "Visa")
            XCTAssertEqual(result.successValue()?.lastFour, "1111")

            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * When: Getting nonce
     * And: The response returns error K0003
     * Then: Resulting error value should be a couldNotReadAuthorisationError
     */
    func testErrorResponse() {
        let expectedError = RawKarhooErrorFactory.buildError(code: "K0003")

        NetworkStub.errorResponse(path: path, responseData: expectedError)

        let expectation = self.expectation(description: "calls the callback with success")

        call.execute(callback: { result in
            let error = result.errorValue()
            XCTAssertEqual(error?.type, .couldNotReadAuthorisationToken)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * When: Getting nonce
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

        waitForExpectations(timeout: 10)
    }
}
