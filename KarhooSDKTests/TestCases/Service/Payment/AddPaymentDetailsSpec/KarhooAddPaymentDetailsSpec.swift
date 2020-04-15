//
//  KarhooAddPaymentDetailsSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class KarhooAddPaymentDetailsSpec: XCTestCase {

    private var testObject: KarhooAddPaymentDetailsInteractor!
    private var mockRequestSender: MockRequestSender!
    private var mockRequest: AddPaymentDetailsPayload!
    private var mockUserDataStore: MockUserDataStore!

    override func setUp() {
        super.setUp()
        mockUserDataStore = MockUserDataStore()

        mockRequest = AddPaymentDetailsPayload(nonce: "n",
                                               payer: Payer(),
                                               organisationId: "elephant")
        mockRequestSender = MockRequestSender()
        testObject = KarhooAddPaymentDetailsInteractor(requestSender: mockRequestSender,
                                                       userDataStore: mockUserDataStore)
        testObject.set(addPaymentDetailsPayload: mockRequest)
    }

    /**
     * When: Adding payment details
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { ( _: Result<KarhooVoid>) in})
        mockRequestSender.assertRequestSendAndDecoded(endpoint: .addPaymentDetails,
                                                      method: .post,
                                                      payload: mockRequest)
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
     * Given: Adding payment details
     * When: Add payment details request succeeds
     * Then: Callback should be success
     * And: Nonce should be persisted to user data store
     */
    func testAddPaymentDetailsSuccess() {
        var callbackResult: Result<Nonce>?
        testObject.execute(callback: { response in
            callbackResult = response
        })

        let response = Nonce(nonce: "some+nonce")
        mockRequestSender.triggerSuccessWithDecoded(value: response)

        XCTAssertEqual("some+nonce", callbackResult!.successValue()?.nonce)
        XCTAssertEqual("some+nonce", mockUserDataStore.updateCurrentNonce?.nonce)
    }

    /**
     * Given: Adding payment details
     * When: Add payment method request fails
     * Then: Callback should contain expected error
     * And: Nonce should NOT be persisted to user data store
     */
    func testAddPaymentDetailsFail() {
        let expectedError = TestUtil.getRandomError()

        var callbackResult: Result<Nonce>?
        testObject.execute(callback: { response in
            callbackResult = response
        })

        mockRequestSender.triggerFail(error: expectedError)
        XCTAssertTrue(expectedError.equals(callbackResult!.errorValue()!))
        XCTAssertFalse(mockUserDataStore.updateCurrentNonceCalled)
        XCTAssertNil(mockUserDataStore.updateCurrentNonce)
    }
}
