//
//  KarhooRefreshTokenInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class KarhooRefreshTokenInteractorSpec: XCTestCase {
    private var testObject: KarhooRefreshTokenInteractor!
    private var mockUserDataStore: MockUserDataStore!
    private var mockRequestSender: MockRefreshTokenRequest!

    override func setUp() {
        super.setUp()
        MockSDKConfig.authenticationMethod = .karhooUser
        mockUserDataStore = MockUserDataStore()
        mockRequestSender = MockRefreshTokenRequest()

        testObject = KarhooRefreshTokenInteractor(dataStore: mockUserDataStore,
                                          refreshTokenRequest: mockRequestSender)
    }

    override class func tearDown() {
        super.tearDown()
        MockSDKConfig.authenticationMethod = .karhooUser
    }

    /**
      * When: Requesting token
      * Then: Request should fire with expected path / method
      */
    func testRefreshRequest() {
        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture())
        mockUserDataStore.credentialsToReturn = credentials

        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user

        testObject.refreshToken(completion: { _ in})

        mockRequestSender.assertRequestSend(endpoint: .karhooUserTokenRefresh, method: .post)
    }

    /**
      * When: Requesting token (Auth settings)
      * Then: Request should fire with expected path / method
      */
    func testAuthRefreshRequest() {
        MockSDKConfig.authenticationMethod = .tokenExchange(settings: MockSDKConfig.tokenExchangeSettings)
        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture())
        mockUserDataStore.credentialsToReturn = credentials

        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user

        testObject.refreshToken(completion: { _ in})

        mockRequestSender.assertRequestSend(endpoint: .authRefresh, method: .post)
    }

    /**
     * When: Using Guest mode
     * Then: Token refresh required should be false
     */
    func testGuestAuthenticationMode() {
        MockSDKConfig.authenticationMethod = .guest(settings: MockSDKConfig.guestSettings)
        testObject.refreshToken(completion: { _ in})

        XCTAssertFalse(testObject.tokenNeedsRefreshing())
    }

    /**
     *  Given:  Credentials authentication token expirationDate is far in the future
     *   When:  tokenNeedsRefreshing method called
     *   Then:  It should return false
     */
    func testTokenDoesntNeedRefreshing() {
        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheFarFuture())
        mockUserDataStore.credentialsToReturn = credentials

        XCTAssertFalse(testObject.tokenNeedsRefreshing())
    }

    /**
     *  Given:  Credentials authentication token expirationDate is near in the future
     *   When:  tokenNeedsRefreshing method called
     *   Then:  It should return true
     */
    func testTokenDoesNeedRefreshingDateFarFuture() {
        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture())
        mockUserDataStore.credentialsToReturn = credentials

        XCTAssertTrue(testObject.tokenNeedsRefreshing())
    }

    /**
     *  Given:  Credentials authentication token expirationDate is in the past
     *   When:  tokenNeedsRefreshing method called
     *   Then:  It should return true
     */
    func testTokenDoesNeedRefreshingPastDate() {
        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInThePast())
        mockUserDataStore.credentialsToReturn = credentials

        XCTAssertTrue(testObject.tokenNeedsRefreshing())
    }

    /**
     *  Given:  Credentials authentication token expirationDate is far in the future
     *   When:  refreshToken method called
     *   Then:  Network request to refresh token is NOT made
     *    And:  Completion block is called with result success(false)
     */
    func testNoRefreshNeeded() {
        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheFarFuture())
        mockUserDataStore.credentialsToReturn = credentials

        var capturedResult: Result<Bool>?
        testObject.refreshToken { result in
            capturedResult = result
        }

        XCTAssertFalse(mockRequestSender.requestCalled)
        XCTAssertTrue(capturedResult!.isSuccess())
        XCTAssertFalse(capturedResult!.successValue()!)
    }

    /**
      * Given: Credentials authentication token expirationDate is nil
      *   When:  tokenNeedsRefreshing method called
      *   Then:  It should return true
      */
    func testNilExpiryDateRefreshCheck() {
        let credentials = Credentials(
            accessToken: "123",
            expiryDate: nil,
            refreshToken: "123",
            refreshTokenExpiryDate: Date().addingTimeInterval(300)
        )
        mockUserDataStore.credentialsToReturn = credentials

        XCTAssertTrue(testObject.tokenNeedsRefreshing())
    }

    /**
     *  Given:  Refresh token not saved in user data store
     *    And:  Token expiration date in near future
     *   When:  refreshToken method called
     *   Then:  Callback should be fired with an error
     */
    func testMissingRefreshToken() {
        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user

        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture(),
                                                                 withRefreshToken: false)
        mockUserDataStore.credentialsToReturn = credentials

        var capturedResult: Result<Bool>?
        testObject.refreshToken { result in
            capturedResult = result
        }

        let returnedError = capturedResult?.errorValue() as? RefreshTokenError
        XCTAssertNotNil(returnedError)
        XCTAssertEqual(.noRefreshToken, returnedError)
    }

    /**
     *  Given:  Refresh token expirationDate is near
     *    And:  refreshToken method called
     *    And:  Network request is made to refresh token
     *   When:  Network request to refresh token returns
     *   Then:  New credentials should be saved in user data store
     */
    func testRefreshSuccess() {
        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user

        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture())
        mockUserDataStore.credentialsToReturn = credentials

        let accessTokenAfterRefresh = TestUtil.getRandomString()
        let successResponse = AuthTokenMock().set(accessToken: accessTokenAfterRefresh).set(expiresIn: 10000)

        var capturedResult: Result<Bool>?
        testObject.refreshToken { result in
            capturedResult = result
        }

        mockRequestSender.success(response: successResponse.build())

        XCTAssertTrue(mockRequestSender.requestCalled)
        XCTAssertTrue(capturedResult!.isSuccess())
        XCTAssertTrue(capturedResult!.successValue()!)
        XCTAssertEqual(mockUserDataStore.storedCredentials?.accessToken, accessTokenAfterRefresh)
    }

    /**
     *  Given:  Refresh token expirationDate is near
     *    And:  refreshToken method called
     *    And:  Network request is made to refresh token
     *   When:  Network request to refresh token fails
     *   Then:  New credentials should NOT be saved in user data store
     *    And:  Callback should return httpClient error
     */
    func testRefreshTokenError() {
        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user

        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture())
        mockUserDataStore.credentialsToReturn = credentials

        let expectedError = TestUtil.getRandomError()

        var capturedResult: Result<Bool>?
        testObject.refreshToken { result in
            capturedResult = result
        }

        mockRequestSender.fail(error: expectedError)

        XCTAssertTrue(mockRequestSender.requestCalled)
        XCTAssertFalse(mockUserDataStore.setCurrentUserCalled)
        XCTAssert(expectedError.equals(capturedResult!.errorValue()!))

    }

    /**
     *  Given:  Refresh token expirationDate is near
     *    And:  User credentials stored in user data store
     *    And:  refreshToken method called
     *    And:  Network request is made to refresh token
     *   When:  Network request to refresh token succeeds
     *    And:  User object is no longer stored in a data store
     *   Then:  New credentials should NOT be saved in user data store
     *    And:  Callback should return userAlreadyLoggedOut error
     */
    func testRefreshTokenErrorUserJustLoggedOut() {
        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user

        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture())
        mockUserDataStore.credentialsToReturn = credentials

        let accessTokenAfterRefresh = TestUtil.getRandomString()

        let requestPayload = AuthTokenMock().set(accessToken: accessTokenAfterRefresh).set(expiresIn: 10000)

        mockRequestSender.beforeResponse = { [weak self] in
            self?.mockUserDataStore.userToReturn = nil
        }

        var capturedResult: Result<Bool>?
        testObject.refreshToken { result in
            capturedResult = result
        }

        mockRequestSender.success(response: requestPayload.build())
        XCTAssertTrue(mockRequestSender.requestCalled)
        XCTAssert(mockUserDataStore.setCurrentUserCalled == false)
        let expectedError = RefreshTokenError.userAlreadyLoggedOut
        let capturedError = capturedResult?.errorValue() as? RefreshTokenError
        XCTAssertNotNil(capturedError)
        XCTAssertEqual(expectedError, capturedError)
    }

    /**
     *  Given:  Refresh token expirationDate is near
     *    And:  User credentials stored in user data store
     *    And:  refreshToken method called
     *    And:  Network request is made to refresh token
     *   When:  Network request to refresh token succeeds
     *    And:  Access token no longer needs refreshing
     *          (it's been refreshed by another request in a meantime)
     *   Then:  Refresh token should NOT be saved to a data store
     *    And:  Callback should return false
     */
    func testTokenAlreadyRefreshed() {
        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user

        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture())
        mockUserDataStore.credentialsToReturn = credentials

        let accessTokenAfterRefresh = TestUtil.getRandomString()
        let requestPayload = AuthTokenMock().set(accessToken: accessTokenAfterRefresh).set(expiresIn: 10000)

        mockRequestSender.beforeResponse = { [weak self] in
            let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: self?.dateInTheFarFuture())
            self?.mockUserDataStore.credentialsToReturn = credentials
        }

        var capturedResult: Result<Bool>?
        testObject.refreshToken { result in
            capturedResult = result
        }

        mockRequestSender.success(response: requestPayload.build())

        XCTAssertFalse(mockUserDataStore.setCurrentUserCalled)
        XCTAssertFalse(capturedResult!.successValue()!)
    }

    private func dateInTheFarFuture() -> Date {
        return TestUtil.getRandomDate(laterThan: Date().addingTimeInterval(3600))
    }

    private func dateInTheNearFuture() -> Date {
        let shortInterval = TimeInterval(Double(TestUtil.getRandomInt(lessThan: 100)) * 0.01)
        return Date().addingTimeInterval(shortInterval)
    }

    private func dateInThePast() -> Date {
        return Date().addingTimeInterval(-400)
    }
}
