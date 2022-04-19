//
//  KarhooAdyenPaymentMethodsInteractorSpec.swift
//  KarhooSDKTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class KarhooAdyenPaymentMethodsInteractorSpec: XCTestCase {
    private var testObject: KarhooAdyenPaymentMethodsInteractor!
    private var mockRequestSender: MockRequestSender!
        
    override func setUp() {
        super.setUp()
        
        mockRequestSender = MockRequestSender()
        testObject = KarhooAdyenPaymentMethodsInteractor(requestSender: mockRequestSender)
        testObject.set(request: AdyenPaymentMethodsRequest())
    }
    
    /**
     * When: Getting Adyen payment methods
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { ( _: Result<DecodableData>) in})
        mockRequestSender.assertRequestSend(endpoint: .adyenPaymentMethods(paymentAPIVersion: ""),
                                            method: .post,
                                            payload: AdyenPaymentMethodsRequest())
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
     * Given: Getting Adyen payment methods
     * When: Get Adyen payment methods request succeeds
     * Then: Callback should be success
     */
    func testPaymentMethodSuccess() {
        var capturedResult: Result<DecodableData>?
        
        testObject.execute(callback: { capturedResult = $0})

        mockRequestSender.triggerSuccess(response: Data())

        XCTAssertNotNil(capturedResult?.successValue())
        XCTAssertEqual(capturedResult?.successValue()?.data, Data())
    }

    /**
     * Given: Getting Adyen payment methods
     * When: Get Adyen payment methods request succeeds
     * Then: Callback should contain expected error
     */
    func testPaymentMethodsFail() {
        let expectedError = TestUtil.getRandomError()

        var capturedResult: Result<DecodableData>?

        testObject.execute(callback: { capturedResult = $0})

        mockRequestSender.triggerFail(error: expectedError)

        XCTAssertNil(capturedResult?.successValue())
        XCTAssert(expectedError.equals(capturedResult!.errorValue()!))
    }
}
