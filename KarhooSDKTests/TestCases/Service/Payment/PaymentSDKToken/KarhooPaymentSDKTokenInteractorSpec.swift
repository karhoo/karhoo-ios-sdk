//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooPaymentSDKTokenInteractorSpec: XCTestCase {

    private var mockPaymentSDKTokenRequest: MockRequestSender!
    private var testObject: KarhooPaymentSDKTokenInteractor!
    private let mockPayload = PaymentSDKTokenPayload(organisationId: "some_org", currency: "GBP")

    override func setUp() {
        super.setUp()

        mockPaymentSDKTokenRequest = MockRequestSender()
        testObject = KarhooPaymentSDKTokenInteractor(request: mockPaymentSDKTokenRequest)
        testObject.set(payload: mockPayload)
    }

    /**
     * When: Getting token
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { result in
            _ = result as Result<PaymentSDKToken>
        })

        mockPaymentSDKTokenRequest.assertRequestSendAndDecoded(endpoint: .paymentSDKToken(payload: mockPayload),
                                                               method: .post,
                                                               payload: nil)
    }

    /**
     * When: Cancelling request
     * Then: Request should cancel
     */
    func testCancelRequest() {
        testObject.cancel()
        XCTAssertTrue(mockPaymentSDKTokenRequest.cancelNetworkRequestCalled)
    }

    /**
      * Given: Getting token
      * When: sdk token request succeeds
      * Then: Callback should contain expected result
      */
    func testSuccessfulTokenFetch() {
        let successResult = PaymentSDKTokenMock().set(token: "some_token")

        var callbackResult: Result<PaymentSDKToken>?
        testObject.execute(callback: { response in
            callbackResult = response
        })

        mockPaymentSDKTokenRequest.triggerSuccessWithDecoded(value: successResult.build())

        XCTAssertEqual("some_token", callbackResult!.successValue()!.token)
    }

    /**
      * Given: Getting token
      * When: sdk token request fails
      * Then: Callback should contain expected result
      */
    func testTokenFetchFails() {
        let expectedError = TestUtil.getRandomError()

        var callbackResult: Result<PaymentSDKToken>?
        testObject.execute(callback: { result in
            callbackResult = result
        })

        mockPaymentSDKTokenRequest.triggerFail(error: expectedError)

        XCTAssertTrue(expectedError.equals(callbackResult!.errorValue()!))
    }
}
