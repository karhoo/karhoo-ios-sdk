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
    }
    
    /**
     * When: Getting Adyen payment methods
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { ( _: Result<AdyenPaymentMethods>) in})
        mockRequestSender.assertRequestSendAndDecoded(endpoint: .adyenPaymentMethods,
                                                      method: .get,
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
     * Given: Getting Adyen payment methods
     * When: Get Adyen payment methods request succeeds
     * Then: Callback should be success
     */
    func testPaymentProviderSuccess() {
        let paymentMethod = AdyenPaymentMethodMock().build()
        let expectedResponse = AdyenPaymentMethods(paymentMethods: [paymentMethod, paymentMethod])
        var expectedResult: Result<AdyenPaymentMethods>?
        
        testObject.execute(callback: { response in
            expectedResult = response
        })

        mockRequestSender.triggerSuccessWithDecoded(value: expectedResponse)

        XCTAssertEqual(2, expectedResult!.successValue()?.paymentMethods.count)
        XCTAssertEqual("some data", expectedResult!.successValue()?.paymentMethods[0].paymentMethodData)
    }

    /**
     * Given: Getting Adyen payment methods
     * When: Get Adyen payment methods request succeeds
     * Then: Callback should contain expected error
     */
    func testPaymentProviderFail() {
        let expectedError = TestUtil.getRandomError()

        var expectedResult: Result<AdyenPaymentMethods>?

        testObject.execute(callback: { expectedResult = $0})

        mockRequestSender.triggerFail(error: expectedError)

        XCTAssertNil(expectedResult?.successValue())
        XCTAssertFalse(expectedResult!.isSuccess())
        XCTAssert(expectedError.equals(expectedResult!.errorValue()!))
    }
}
