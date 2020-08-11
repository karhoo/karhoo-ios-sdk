//
//  PaymentProviderInteractor.swift
//  KarhooSDKTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//
import XCTest
@testable import KarhooSDK

final class KarhooPaymentProviderInteractorSpec: XCTestCase {
    private var testObject: KarhooPaymentProviderInteractor!
    private var mockRequestSender: MockRequestSender!
    
    override func setUp() {
        super.setUp()

        mockRequestSender = MockRequestSender()
        testObject = KarhooPaymentProviderInteractor(requestSender: mockRequestSender)
    }
    
    /**
     * When: Adding payment details
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { ( _: Result<PaymentProvider>) in})
        mockRequestSender.assertRequestSendAndDecoded(endpoint: .paymentProvider,
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
     * Given: Getting payment provider
     * When: Get payment provider request succeeds
     * Then: Callback should be success
     */
    func testPaymentProviderSuccess() {
        let expectedResponse = PaymentProvider(id: "some_id", loyaltyProgammes: [])
        var expectedResult: Result<PaymentProvider>?
        
        testObject.execute(callback: { expectedResult = $0})

        mockRequestSender.triggerSuccessWithDecoded(value: expectedResponse)

        XCTAssertEqual("some_id", expectedResult!.successValue()?.id)
    }

    /**
     * Given: Getting payment provider
     * When: Get payment provider request succeeds
     * Then: Callback should contain expected error
     */
    func testPaymentProviderFail() {
        let expectedError = TestUtil.getRandomError()

        var expectedResult: Result<PaymentProvider>?

        testObject.execute(callback: { expectedResult = $0})

        mockRequestSender.triggerFail(error: expectedError)

        XCTAssertNil(expectedResult?.successValue())
        XCTAssertFalse(expectedResult!.isSuccess())
        XCTAssert(expectedError.equals(expectedResult!.errorValue()!))
    }
}
