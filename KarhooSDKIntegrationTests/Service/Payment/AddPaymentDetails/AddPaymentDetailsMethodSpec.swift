//
//  AddPaymentDetailsSpec.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class AddPaymentDetailsMethodSpec: XCTestCase {

    private var paymentService: PaymentService!
    private let path = "/v2/payments/payment-methods/braintree/add-payment-details"
    private var call: Call<Nonce>!

    override func setUp() {
        super.setUp()

        self.paymentService = Karhoo.getPaymentService()

        let payload = AddPaymentDetailsPayload(nonce: "some", payer: Payer(), organisationId: "some+desiredOrg")
        self.call = paymentService.addPaymentDetails(addPaymentDetailsPayload: payload)
        
    }

    /**
     * When: Adding payment details
     * And: The response returns successful
     * Then: Result is success
     */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "AddPaymentDetails.json", path: path)

        let expectation = self.expectation(description: "calls the callback with success")

        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            XCTAssertEqual(result.getSuccessValue()?.cardType, "Visa")
            XCTAssertEqual(result.getSuccessValue()?.lastFour, "1111")
            XCTAssertEqual(result.getSuccessValue()?.nonce, "some_nonce")

            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * When: Adding payment details
     * And: The response returns error K0003
     * Then: Resulting error value should be a couldNotReadAuthorisationError
     */
    func testErrorResponse() {
        let expectedError = RawKarhooErrorFactory.buildError(code: "K0003")

        NetworkStub.errorResponse(path: path, responseData: expectedError)

        let expectation = self.expectation(description: "calls the callback with success")

        call.execute(callback: { result in
            let error = result.getErrorValue()
            XCTAssertEqual(error?.type, .couldNotReadAuthorisationToken)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 20)
    }

    /**
     * When: Adding payment details
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

        waitForExpectations(timeout: 10)
    }
}
