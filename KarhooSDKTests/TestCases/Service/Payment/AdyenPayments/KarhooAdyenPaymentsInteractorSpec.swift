//
//  KarhooAdyenPaymentsInteractorSpec.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 25/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class KarhooAdyenPaymentsInteractorSpec: XCTestCase {
    
    private var testObject: KarhooAdyenPaymentsInteractor!
    private var mockRequestSender: MockRequestSender!
    
    override func setUp() {
        super.setUp()
        
        mockRequestSender = MockRequestSender()
        testObject =
            KarhooAdyenPaymentsInteractor(requestSender: mockRequestSender)
    }
    
    
    /**
     * When: Getting Adyen payments
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { ( _: Result<AdyenPayments>) in})
        mockRequestSender.assertRequestSendAndDecoded(endpoint: .adyenPayments(paymentAPIVersion: ""),
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
    func testPaymentsSuccess() {
        let expectedResponse = AdyenPayments(tripId: "mock", payload: ["":""])
        var expectedResult: Result<AdyenPayments>?
        
        testObject.execute(callback: { response in
            expectedResult = response
        })
        
        mockRequestSender.triggerSuccessWithDecoded(value: expectedResponse)
        
        XCTAssertEqual("mock", expectedResult!.getSuccessValue()?.tripId)
    }
    
    /**
     * Given: Getting Adyen payments
     * When: Get Adyen payments request succeeds
     * Then: Callback should contain expected error
     */
    func testPaymentsFail() {
        let expectedError = TestUtil.getRandomError()

        var expectedResult: Result<AdyenPayments>?

        testObject.execute(callback: { expectedResult = $0})

        mockRequestSender.triggerFail(error: expectedError)

        XCTAssertNil(expectedResult?.getSuccessValue())
        XCTAssertFalse(expectedResult!.isSuccess())
        XCTAssert(expectedError.equals(expectedResult!.getErrorValue()!))
    }
}
