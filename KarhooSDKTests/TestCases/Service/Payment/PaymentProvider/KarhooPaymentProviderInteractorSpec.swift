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
    private var mockUserDataStore = MockUserDataStore()

    override func setUp() {
        super.setUp()

        mockRequestSender = MockRequestSender()
        testObject = KarhooPaymentProviderInteractor(requestSender: mockRequestSender, userDataStore: mockUserDataStore)
    }
    
    /**
     * When: Getting payment provider
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
     * Given: Getting the payment provider
     * When: Get payment provider request succeeds
     * Then: Callback should be success
     * And: payment provider should be persisted to user data store
     */
    func testPaymentProviderSuccess() {
        let expectedResponse = PaymentProvider(provider: Provider(id: "braintree"), version: "v68")
        var expectedResult: Result<PaymentProvider>?
        
        testObject.execute(callback: { expectedResult = $0})

        mockRequestSender.triggerSuccessWithDecoded(value: expectedResponse)

        XCTAssertEqual(.braintree, mockUserDataStore.updatedPaymentProvider!.provider.type)
        XCTAssertEqual(.braintree, expectedResult!.successValue()?.provider.type)
    }

    /**
     * Given: Getting the payment provider
     * When: Get payment provider request succeeds
     * Then: Callback should contain expected error
     * And: No provider is persisted
     */
    func testPaymentProviderFail() {
        let expectedError = TestUtil.getRandomError()

        var expectedResult: Result<PaymentProvider>?

        testObject.execute(callback: { expectedResult = $0})

        mockRequestSender.triggerFail(error: expectedError)

        XCTAssertNil(expectedResult?.successValue())
        XCTAssertNil(mockUserDataStore.updatedPaymentProvider)
        XCTAssertFalse(expectedResult!.isSuccess())
        XCTAssert(expectedError.equals(expectedResult!.errorValue()!))
    }
}
