//
//  KarhooGetNonceInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class KarhooGetNonceInteractorSpec: XCTestCase {

    private var mockGetNonceRequest: MockRequestSender!
    private var testObject: KarhooGetNonceInteractor!
    private var mockNonceRequestPayload: NonceRequestPayload!
    private var mockUserDataStore = MockUserDataStore()

    override func setUp() {
        super.setUp()
        mockGetNonceRequest = MockRequestSender()
        testObject = KarhooGetNonceInteractor(request: mockGetNonceRequest,
                                              userDataStore: mockUserDataStore)

        let mockPayer = Payer(id: "some_id",
                              firstName: "some_first",
                              lastName: "some_last",
                              email: "some_email")

        mockNonceRequestPayload = NonceRequestPayloadMock()
            .set(payer: mockPayer)
            .set(organisationId: "some_desiredOrg")
            .build()

        testObject.set(nonceRequestPayload: mockNonceRequestPayload)
    }

    /**
     * When: Getting nonce
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { ( _: Result<Nonce>) in})
        mockGetNonceRequest.assertRequestSendAndDecoded(endpoint: .getNonce,
                                                        method: .post,
                                                        payload: mockNonceRequestPayload)
    }

    /**
     * When: Cancelling request
     * Then: request should cancel
     */
    func testCancelRequest() {
        testObject.cancel()
        XCTAssertTrue(mockGetNonceRequest.cancelNetworkRequestCalled)
    }

    /**
     * Given: Getting nonce
     * When: method request succeeds
     * Then: Callback should be success
     * And: Nonce should be saved to the user data store
     */
    func testGetNonceSuccess() {
        var callbackResult: Result<Nonce>?
        testObject.execute(callback: { response in
            callbackResult = response
        })

        mockGetNonceRequest.triggerSuccessWithDecoded(value: Nonce(nonce: "some_nonce"))
        XCTAssertEqual(callbackResult!.successValue()?.nonce, "some_nonce")
        XCTAssertEqual(mockUserDataStore.updateCurrentNonce?.nonce, "some_nonce")
    }

    /**
     * Given: Getting nocne
     * When:  method request fails
     * Then:  Callback should contain expected error
     * And: User should be updated with a new nonce
     */
    func testGetNonceFail() {
        let expectedError = TestUtil.getRandomError()

        var callbackResult: Result<Nonce>?
        testObject.execute(callback: { response in
            callbackResult = response
        })

        mockGetNonceRequest.triggerFail(error: expectedError)
        XCTAssertTrue(expectedError.equals(callbackResult?.errorValue()!))
        XCTAssertTrue(mockUserDataStore.updateCurrentNonceCalled)
    }
}
