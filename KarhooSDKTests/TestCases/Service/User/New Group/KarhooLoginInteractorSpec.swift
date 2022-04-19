//
//  KarhooLoginInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

class KarhooLoginInteractorSpec: XCTestCase {
    private var mockLoginRequestSender: MockRequestSender!
    private var mockProfileRequestSender: MockRequestSender!
    private var mockAnalytics: MockAnalyticsService!
    private var mockUserDataStore: MockUserDataStore!
    private var mockGetNonceRequestSender: MockRequestSender!
    private var mockPaymentProviderRequest = MockRequestSender()
    private var mockLoyaltyProviderRequest = MockRequestSender()
    private var testObject: KarhooLoginInteractor!

    override func setUp() {
        super.setUp()

        mockAnalytics = MockAnalyticsService()
        mockLoginRequestSender = MockRequestSender()
        mockProfileRequestSender = MockRequestSender()
        mockUserDataStore = MockUserDataStore()
        mockGetNonceRequestSender = MockRequestSender()

        testObject = KarhooLoginInteractor(userDataStore: mockUserDataStore,
                                           loginRequestSender: mockLoginRequestSender,
                                           profileRequestSender: mockProfileRequestSender,
                                           analytics: mockAnalytics,
                                           nonceRequestSender: mockGetNonceRequestSender,
                                           paymentProviderRequest: mockPaymentProviderRequest,
                                           loyaltyProviderRequest: mockLoyaltyProviderRequest)
    }

    /**
      * When: Cancelling login
      * Then: login request and profile requests should be cancelled
      */
    func testCancel() {
        testObject.cancel()
        XCTAssertTrue(mockLoginRequestSender.cancelNetworkRequestCalled)
        XCTAssertTrue(mockProfileRequestSender.cancelNetworkRequestCalled)
    }

    /**
     *  Given:  The user which we attempt to log in is already logged in
     *  When:   Logging in
     *  Then:   The currently logged in user should be returned
     */
    func testLoginExistingUser() {
        let existingUser = UserInfoMock().set(userId: "some").build()
        let userLogin = UserLogin(username: existingUser.email, password: "some")

        mockUserDataStore.userToReturn = existingUser

        var result: Result<UserInfo>?
        testObject.set(userLogin: userLogin)
        testObject.execute(callback: { result = $0 })

        XCTAssertEqual(existingUser, result?.successValue())
    }

    /**
     *  Given:  Another user than the one  we attempt to log in is already
     *          logged in
     *  When:   Logging in
     *  Then:   The caller should get an error that there is another user
     *          currently logged in
     */
    func testLoginOtherUser() {
        let existingUser = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = existingUser

        var returnedError: Error?
        let userLogin = UserLogin(username: "some other email", password: "some")
        testObject.set(userLogin: userLogin)
        testObject.execute(callback: { (result: Result<UserInfo>) in
            returnedError = result.errorValue()
        })

        XCTAssertNotNil(returnedError)
    }

    /**
     *  Given:  No currently logged in user
     *  When:   Logging in
     *  Then:   A login request should be sent
     */
    func testNoLoggedInUser() {
        let userLogin = UserLogin(username: "email@email.com", password: "password")

        testObject.set(userLogin: userLogin)
        testObject.execute(callback: { (_: Result<UserInfo>) in })

        mockLoginRequestSender.assertRequestSendAndDecoded(endpoint: .login,
                                                           method: .post,
                                                           payload: userLogin)
    }
    
    /**
     *  Given:  A sent login request
     *  When:   The request succeeds
     *  Then:   The profile request succeeds
     *   And:   The user HAS the trip admin role
     *  Then:   Credentials should be saved to datas store
     *   And:   The user should be stored
     *   And:   Analytics should fire with the user
     */
    func testRoleAuthorised() {
       [Organisation(id: "some", name: "some", roles: ["MOBILE_USER", "USER"]),
        Organisation(id: "some", name: "some", roles: ["MOBILE_USER", "TRIP_ADMIN", "USER"]),
        Organisation(id: "some", name: "some", roles: ["TRIP_ADMIN", "USER"])].forEach({ org in
            loginAndProfileAssertSuccess(organisations: [org])
        })
    }

    private func loginAndProfileAssertSuccess(organisations: [Organisation]) {
        var returnedUser: UserInfo?
        
        let userLogin = UserLogin(username: "email", password: "password")
        
        testObject.set(userLogin: userLogin)
        testObject.execute(callback: { (result: Result<UserInfo>) in
            returnedUser = result.successValue()
        })
        
        let loginResult = AuthTokenMock().set(accessToken: "some_token")
            .set(refreshToken: "some_refresh_token")
            .set(expiresIn: 60)
            .build()
        
        mockLoginRequestSender.triggerSuccessWithDecoded(value: loginResult)
        
        let userMock = UserInfoMock().set(userId: "123").set(organisation: organisations)
        
        mockProfileRequestSender.triggerSuccessWithDecoded(value: userMock.build())
        
        XCTAssertEqual(userMock.build(), returnedUser)
        XCTAssertEqual(mockUserDataStore.credentialsToSet?.accessToken, "some_token")
        XCTAssertEqual(userMock.build(), mockUserDataStore.storedUser)
        
        XCTAssertEqual(mockUserDataStore.credentialsToSet?.accessToken, "some_token")
    }

    /**
     *  Given:  A sent login request
     *  When:   The request succeeds
     *  Then:   The profile request succeeds
     *   And:   The user doesn't have the trip admin role
     *  Then:   Credentials should be set
     *   And:   logged in analytics event should not be fired
     *   And:   Callbackshould be a fail with an unauthorised error
     */
    func testUnauthorisedRoleLoginAttempt() {
        
        let userLogin = UserLogin(username: "email", password: "password")

        var result: Result<UserInfo>?
        testObject.set(userLogin: userLogin)
        testObject.execute(callback: { result = $0 })

        let loginResult = AuthTokenMock().set(accessToken: "some_token")
            .set(refreshToken: "some_refresh_token")
            .set(expiresIn: 60)
            .build()

        mockLoginRequestSender.triggerSuccessWithDecoded(value: loginResult)
        
        let unauthorizedOrganisationRole = Organisation(id: "some", name: "some", roles: ["USER"])

        let userMock = UserInfoMock().set(userId: "123").set(organisation: [unauthorizedOrganisationRole])
        
        mockProfileRequestSender.triggerSuccessWithDecoded(value: userMock.build())

        XCTAssertEqual(mockUserDataStore.credentialsToSet?.accessToken, "some_token")
        XCTAssertNil(mockUserDataStore.storedUser)
        XCTAssertEqual(.missingUserPermission, result?.errorValue()?.type)
        XCTAssertNil(result?.successValue())
        XCTAssert(result?.isSuccess() == false)
    }

    /**
     * Given:   A sent login request
     *  When:   The request succeeds
     *  Then:   Credentials should be set
     *   And:   The profile request fails
     *  Then:   callback should fail
     *   And:   analytics shouldn't be fired
     */
    func testSuccessfulLoginAndProfileFetchFail() {
        let expectedError = TestUtil.getRandomError()

        let userLogin = UserLogin(username: "email", password: "password")
        var result: Result<UserInfo>?
        testObject.set(userLogin: userLogin)
        testObject.execute(callback: { result = $0 })

        let loginResult = AuthTokenMock().set(accessToken: "some_token")
            .set(refreshToken: "some_refresh_token")
            .set(expiresIn: 60)
            .build()

        mockLoginRequestSender.triggerSuccessWithDecoded(value: loginResult)

        XCTAssertEqual(mockUserDataStore.credentialsToSet?.accessToken, "some_token")

        mockProfileRequestSender.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result!.errorValue()))
    }

    /**
     *  Given:  A sent login request
     *  When:   The request fails
     *  Then:   The caller should be informed
     *  And:    Profile fetch should NOT be made
     *  And:    No credentials should be saved
     */
    func testFailedLogin() {
        let expectedError = TestUtil.getRandomError()
        let userLogin = UserLogin(username: "email", password: "password")

        var result: Result<UserInfo>?
        testObject.set(userLogin: userLogin)
        testObject.execute(callback: { result = $0 })

        mockLoginRequestSender.triggerFail(error: expectedError)

        XCTAssertNil(mockUserDataStore.credentialsToSet)
        XCTAssertFalse(mockProfileRequestSender.requestCalled)
        XCTAssert(expectedError.equals(result!.errorValue()))
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

        triggerSuccessfulLoginAndProfileFetch()
        let paymentProvider = PaymentProvider(provider: Provider(id: "braintree"), version: "v68")
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
        let successNonce = Nonce(nonce: "some_nonce",
                                 cardType: "Visa",
                                 lastFour: "1234")
        let paymentProvider = PaymentProvider(provider: Provider(id: "braintree"), version: "v68")
        triggerSuccessfulLoginAndProfileFetch()
        mockGetNonceRequestSender.triggerSuccessWithDecoded(value: successNonce)
        mockPaymentProviderRequest.triggerSuccessWithDecoded(value: paymentProvider)

        XCTAssertEqual(.braintree, mockUserDataStore.updatedPaymentProvider?.provider.type)
    }
    
    /**
     * Given: Login successful
     * When: provider call succeeds
     * Then: loyalty status should be updated
     */
    func testLoyaltyStatusIsUpdated() {
        let paymentProvider = PaymentProvider(provider: Provider(id: "braintree"),
                                              version: "v68",
                                              loyaltyProgamme: LoyaltyProgramme(id: "some", name: TestUtil.getRandomString()))
        let loyaltyStatus = LoyaltyStatus(balance: TestUtil.getRandomInt(), canBurn: false, canEarn: true)

        triggerSuccessfulLoginAndProfileFetch()

        mockPaymentProviderRequest.triggerSuccessWithDecoded(value: paymentProvider)
        mockLoyaltyProviderRequest.triggerSuccessWithDecoded(value: loyaltyStatus)

        XCTAssertEqual("some", mockUserDataStore.updatedPaymentProvider?.loyaltyProgamme.id)
    }

    /**
     * Given: Login successful and the payment provider is braintree
     * When: Nonce fails
     * Then: User should be updated
     */
    func testGetNonceFailsAfterSuccessfulLogin() {
        triggerSuccessfulLoginAndProfileFetch()
        let paymentProvider = PaymentProvider(provider: Provider(id: "braintree"), version: "v68")
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
        triggerSuccessfulLoginAndProfileFetch()
        let paymentProvider = PaymentProvider(provider: Provider(id: "adyen"), version: "v68")
        mockPaymentProviderRequest.triggerSuccessWithDecoded(value: paymentProvider)

        mockGetNonceRequestSender.triggerFail(error: TestUtil.getRandomError())

        XCTAssertFalse(mockGetNonceRequestSender.requestAndDecodeCalled)
        XCTAssertFalse(mockUserDataStore.updateCurrentNonceCalled)
        XCTAssertNil(mockUserDataStore.updateCurrentNonce)
    }

    private func triggerSuccessfulLoginAndProfileFetch() {
        let userLogin = UserLogin(username: "email", password: "password")

        testObject.set(userLogin: userLogin)
        testObject.execute(callback: { (_: Result<UserInfo>) in })

        let loginResult = AuthTokenMock().set(accessToken: "some_token")
            .set(refreshToken: "some_refresh_token")
            .set(expiresIn: 60)
            .build()

        mockLoginRequestSender.triggerSuccessWithDecoded(value: loginResult)

        let authorizedOrganisationRole = Organisation(id: "some", name: "some", roles: ["TRIP_ADMIN"])

        let userMock = UserInfoMock().set(userId: "123").set(organisation: [authorizedOrganisationRole])

        mockProfileRequestSender.triggerSuccessWithDecoded(value: userMock.build())
    }
}
