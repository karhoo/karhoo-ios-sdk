//
//  KarhooAuthLoginInteractorSpec.swift
//  KarhooSDKTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooSDK

final class KarhooAuthLoginInteractorSpec: XCTestCase {

    private var testObject: KarhooAuthLoginWithTokenInteractor!
    private var mocktokenExchangeRequest: MockRequestSender!
    private var mockUserRequest: MockRequestSender!
    private var mockUserDataStore: MockUserDataStore!
    private var mockAnalytics: MockAnalyticsService!
    private var mockPaymentService = MockPaymentProviderInteractor()
    private var mockPaymentProviderRequest = MockRequestSender()
    private var mockGetNonceRequestSender: MockRequestSender!

    override func setUp() {
        super.setUp()
        
        mocktokenExchangeRequest = MockRequestSender()
        mockAnalytics = MockAnalyticsService()
        mockUserRequest = MockRequestSender()
        mockUserDataStore = MockUserDataStore()
        mockAnalytics = MockAnalyticsService()
        mockGetNonceRequestSender = MockRequestSender()
    
        testObject = KarhooAuthLoginWithTokenInteractor(tokenExchangeRequestSender: mocktokenExchangeRequest,
                                               userInfoSender: mockUserRequest,
                                               userDataStore: mockUserDataStore,
                                               analytics: mockAnalytics,
                                               paymentProviderRequest: mockPaymentProviderRequest,
                                               nonceRequestSender: mockGetNonceRequestSender)
        testObject.set(token: "13123123123123")
    }

    /**
      * When: Cancelling revoke
      * Then: Login request should be cancelled
      */
    func testCancel() {
        testObject.cancel()
        XCTAssertTrue(mocktokenExchangeRequest.cancelNetworkRequestCalled)
        XCTAssertTrue(mockUserRequest.cancelNetworkRequestCalled)
    }
    
    /**
     * Given: Exchange token
     * When: Login and user info request succeeds
     * Then: expected result should propagate
     */
    func testLoginHappyPath() {
        var result: Result<UserInfo>?
        
        testObject.execute(callback: { result = $0 })
        mocktokenExchangeRequest.triggerEncodedRequestSuccess(value: AuthTokenMock().set(accessToken: "123").build())
        mockUserRequest.triggerSuccessWithDecoded(value: UserInfoMock().set(firstName: "Bob").build())
        
        XCTAssertEqual("123", mockUserDataStore.credentialsToSet?.accessToken)
        XCTAssertTrue(mockUserDataStore.setCurrentUserCalled)
        XCTAssertEqual(mockAnalytics.eventSent, .ssoUserLogIn)
        XCTAssertNotNil(result!.successValue())
    }

    /**
     * Given: Exchange token
     * When: Login fails
     * Then: User profile request should not be sent
     * And: Error should be propogated
     * And: No credentials or user should be set
     */
    func testTokenRequestFails() {
        var result: Result<UserInfo>?
        let expectedError = TestUtil.getRandomError()
        testObject.execute(callback: { result = $0 })
        mocktokenExchangeRequest.triggerFail(error: expectedError)

        XCTAssertFalse(mockUserRequest.requestAndDecodeCalled)
        XCTAssertNil(mockUserDataStore.credentialsToSet)
        XCTAssertNotNil(result!.errorValue())
    }

    /**
     * Given: Exchange token successful
     * When: User profile request  fails
     * Then:
     */
    func testUserRequestFails() {
        var result: Result<UserInfo>?
        let expectedError = TestUtil.getRandomError()
        testObject.execute(callback: { result = $0 })
        mocktokenExchangeRequest.triggerEncodedRequestSuccess(value: AuthTokenMock().set(accessToken: "123").build())
        mockUserRequest.triggerFail(error: expectedError)

        XCTAssertNotNil(result!.errorValue())
        XCTAssertNil(mockAnalytics.eventSent)
    }

    /**
      * Given: Login successful and the payment provider is braintree
      * When: Nonce succeeds
      * Then: User should be updated
      */
    func testGetNonceSuccessAfterLogin() {
        let successNonce = Nonce(nonce: "some_nonce",
                                cardType: "Visa",
                                lastFour: "1234")

        triggerSuccessfulAuthLoginAndProfileFetch()
        let paymentProvider = PaymentProvider(provider: Provider(id: "braintree"))
        mockPaymentProviderRequest.triggerSuccessWithDecoded(value: paymentProvider)

        XCTAssertTrue(mockGetNonceRequestSender.requestAndDecodeCalled)

        mockGetNonceRequestSender.triggerSuccessWithDecoded(value: successNonce)

        XCTAssertTrue(mockUserDataStore.updateCurrentNonceCalled)
        XCTAssertEqual("some_nonce", successNonce.nonce)
    }

    /**
     * Given: Login successful
     * When: provider call succeeds
     * Then: User should be updated
     */
    func testGetPaymentProvider() {
        let paymentProvider = PaymentProvider(provider: Provider(id: "braintree"))

        triggerSuccessfulAuthLoginAndProfileFetch()

        mockPaymentProviderRequest.triggerSuccessWithDecoded(value: paymentProvider)

        XCTAssertEqual(.braintree, mockUserDataStore.updatedPaymentProvider?.provider.type)
    }

    /**
     * Given: Login successful and the payment provider is braintree
     * When: Nonce fails
     * Then: User should be updated
     */
    func testGetNonceFailsAfterSuccessfulLogin() {
        triggerSuccessfulAuthLoginAndProfileFetch()
        let paymentProvider = PaymentProvider(provider: Provider(id: "braintree"))
        mockPaymentProviderRequest.triggerSuccessWithDecoded(value: paymentProvider)

        mockGetNonceRequestSender.triggerFail(error: TestUtil.getRandomError())

        XCTAssertTrue(mockGetNonceRequestSender.requestAndDecodeCalled)
        XCTAssertTrue(mockUserDataStore.updateCurrentNonceCalled)
        XCTAssertNil(mockUserDataStore.updateCurrentNonce)
    }

    /**
     * Given: Login successful and the payment
     * When: provider is adyen
     * Then: get nonce should not be called
     */
    func testAdyenDoesNotGetBraintreeNonce() {
        triggerSuccessfulAuthLoginAndProfileFetch()
        let paymentProvider = PaymentProvider(provider: Provider(id: "adyen"))
        mockPaymentProviderRequest.triggerSuccessWithDecoded(value: paymentProvider)

        mockGetNonceRequestSender.triggerFail(error: TestUtil.getRandomError())

        XCTAssertFalse(mockGetNonceRequestSender.requestAndDecodeCalled)
        XCTAssertFalse(mockUserDataStore.updateCurrentNonceCalled)
        XCTAssertNil(mockUserDataStore.updateCurrentNonce)
    }

    private func triggerSuccessfulAuthLoginAndProfileFetch() {
        testObject.execute(callback: { (_: Result<UserInfo>) in })
        mocktokenExchangeRequest.triggerEncodedRequestSuccess(value: AuthTokenMock().set(accessToken: "123").build())
        mockUserRequest.triggerSuccessWithDecoded(value: UserInfoMock().set(firstName: "Bob").build())
    }

}
