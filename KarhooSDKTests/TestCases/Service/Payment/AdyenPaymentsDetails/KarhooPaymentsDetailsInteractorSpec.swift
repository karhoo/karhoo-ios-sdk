//
//  KarhooPaymentsDetailsInteractorSpec.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 01/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class KarhooAdyenPaymentsDetailsInteractorSpec: XCTestCase {
    
    private var testObject: KarhooAdyenPaymentsDetailsInteractor!
    private var mockRequestSender: MockRequestSender!
    
    override func setUp() {
        super.setUp()
        
        mockRequestSender = MockRequestSender()
        testObject =
            KarhooAdyenPaymentsDetailsInteractor(requestSender: mockRequestSender)
    }
    
    
    /**
     * When: Getting Adyen payments
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { ( _: Result<AdyenPaymentsDetails>) in})
        mockRequestSender.assertRequestSendAndDecoded(endpoint: .adyenPaymentsDetails,
                                                      method: .post,
                                                      payload: nil)
    }
    
    /**
     * When: Cancelling request
     * Then: request should cancel
     */
    func testCancelRequest() {
        testObject.cancel()
        XCTAssertTrue(mockRequestSender.cancelNetworkRequestCalled)
    }

    /**
     * Given: Getting Adyen payments
     * When: Get Adyen payments request succeeds
     * Then: Callback should be success
     */
    func testPaymentProviderSuccess() {
        let mockpayment = AdyenPaymentsDetailsRequest(paymentData: "mock")

        let expectedResponse = PaymentsDetailsRequestPayload(transactionID: "", paymentsPayload: mockpayment)
        var expectedResult: Result<AdyenPaymentsDetails>?

        testObject.execute(callback: { response in
            expectedResult = response
        })

        mockRequestSender.triggerSuccessWithDecoded(value: expectedResponse)

        XCTAssertEqual("mock", expectedResult!.successValue()?)
    }

    /**
     * Given: Getting Adyen payments
     * When: Get Adyen payments request succeeds
     * Then: Callback should contain expected error
     */
    func testPaymentFail() {
        let expectedError = TestUtil.getRandomError()

        var expectedResult: Result<AdyenPaymentsDetails>?

        testObject.execute(callback: { expectedResult = $0})

        mockRequestSender.triggerFail(error: expectedError)

        XCTAssertNil(expectedResult?.successValue())
        XCTAssertFalse(expectedResult!.isSuccess())
        XCTAssert(expectedError.equals(expectedResult!.errorValue()!))
    }
}
