//
//  KarhooAuthLoginWithCredentialsSpec.swift
//  KarhooSDKTests
//
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooSDK

final class KarhooAuthLoginWithCredentialsSpec: XCTestCase {
    
    private var testObject: KarhooAuthLoginWithCredentialsInteractor!
    private var mockUserRequest: MockRequestSender!
    private var mockUserDataStore: MockUserDataStore!
    private var mockAnalytics: MockAnalyticsService!
    private var mockPaymentService = MockPaymentProviderInteractor()
    private var mockPaymentProviderRequest = MockRequestSender()
    private var mockLoyaltyProviderRequest = MockRequestSender()
    private var mockGetNonceRequestSender: MockRequestSender!
    
    override func setUp() {
        super.setUp()
        
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
        testObject = KarhooAuthLoginWithCredentialsInteractor(
            userInfoSender: mockUserRequest,
            userDataStore: mockUserDataStore,
            analytics: mockAnalytics,
            paymentProviderRequest: mockPaymentProviderRequest,
            loyaltyProviderRequest: mockLoyaltyProviderRequest,
            nonceRequestSender: mockGetNonceRequestSender,
            paymentProviderUpdateHandler: mockPaymentProviderUpdateHandler
        )
        testObject.set(auth: AuthToken(accessToken: "123123123", expiresIn: 5, refreshToken: "123123123", refreshExpiresIn: 5))
    }
    
    /**
      * When: Cancelling revoke
      * Then: Login request should be cancelled
      */
    func testCancel() {
        testObject.cancel()
        XCTAssertTrue(mockUserRequest.cancelNetworkRequestCalled)
    }
    
    /**
     * Given: Auth token is provided
     * When: Login and user info request succeeds
     * Then: expected result should propagate
     */
    func testLoginHappyPath() {
        var result: Result<UserInfo>?
        
        testObject.execute(callback: { result = $0 })
        mockUserRequest.triggerSuccessWithDecoded(value: UserInfoMock().set(firstName: "Bob").build())
        
        XCTAssertEqual("123123123", mockUserDataStore.credentialsToSet?.accessToken)
        XCTAssertTrue(mockUserDataStore.setCurrentUserCalled)
        XCTAssertEqual(mockAnalytics.eventSent, .ssoUserLogIn)
        XCTAssertNotNil(result!.getSuccessValue())
    }

    /**
     * Given: User never signed in
     * When: Attempt to sign in to reauthenticate fails
     * Then: User profile request should not be sent
     * And: Error should be propogated
     * And: No credentials or user should be set
     */
    func testAuthRequestFails() {
        var result: Result<UserInfo>?
        testObject.set(auth: nil)
        testObject.execute(callback: { result = $0 })

        XCTAssertFalse(mockUserRequest.requestAndDecodeCalled)
        XCTAssertNil(mockUserDataStore.credentialsToSet)
        XCTAssertNotNil(result!.getErrorValue())
    }

    /**
     * Given: AuthToken successful
     * When: User profile request  fails
     * Then: Error is returned and analytics is sent
     */
    func testUserRequestFails() {
        var result: Result<UserInfo>?
        let expectedError = TestUtil.getRandomError()
        testObject.execute(callback: { result = $0 })
        mockUserRequest.triggerFail(error: expectedError)

        XCTAssertNotNil(result!.getErrorValue())
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
        mockUserRequest.triggerSuccessWithDecoded(value: UserInfoMock().set(firstName: "Bob").build())
    }
    
}
