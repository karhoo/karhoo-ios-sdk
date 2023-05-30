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
    private var mockLoyaltyProviderRequest = MockRequestSender()
    private var mockGetNonceRequestSender: MockRequestSender!

    override func setUp() {
        super.setUp()
        
        mocktokenExchangeRequest = MockRequestSender()
        mockAnalytics = MockAnalyticsService()
        mockUserRequest = MockRequestSender()
        mockUserDataStore = MockUserDataStore()
        mockAnalytics = MockAnalyticsService()
        mockGetNonceRequestSender = MockRequestSender()
    
        let mockPaymentProviderUpdateHandler = KarhooPaymentProviderUpdateHandler(
            userDataStore: mockUserDataStore,
            nonceRequestSender: mockGetNonceRequestSender,
            paymentProviderRequest: mockPaymentProviderRequest,
            loyaltyProviderRequest: mockLoyaltyProviderRequest
        )
        testObject = KarhooAuthLoginWithTokenInteractor(
            tokenExchangeRequestSender: mocktokenExchangeRequest,
            userInfoSender: mockUserRequest,
            userDataStore: mockUserDataStore,
            analytics: mockAnalytics,
            paymentProviderUpdateHandler: mockPaymentProviderUpdateHandler
        )
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
     * Given: Login successful
     * When: provider call succeeds
     * Then: loyalty status should be updated
     */
    func testLoyaltyStatusIsUpdated() {
        let paymentProvider = PaymentProvider(provider: Provider(id: "braintree"), loyaltyProgamme: LoyaltyProgramme(id: "some", name: TestUtil.getRandomString()))
        let loyaltyStatus = LoyaltyStatus(balance: TestUtil.getRandomInt(), canBurn: false, canEarn: true)

        triggerSuccessfulAuthLoginAndProfileFetch()

        mockPaymentProviderRequest.triggerSuccessWithDecoded(value: paymentProvider)
        mockLoyaltyProviderRequest.triggerSuccessWithDecoded(value: loyaltyStatus)

        XCTAssertEqual("some", mockUserDataStore.updatedPaymentProvider?.loyaltyProgamme.id)
    }

    private func triggerSuccessfulAuthLoginAndProfileFetch() {
        testObject.execute(callback: { (_: Result<UserInfo>) in })
        mocktokenExchangeRequest.triggerEncodedRequestSuccess(value: AuthTokenMock().set(accessToken: "123").build())
        mockUserRequest.triggerSuccessWithDecoded(value: UserInfoMock().set(firstName: "Bob").build())
    }

}
