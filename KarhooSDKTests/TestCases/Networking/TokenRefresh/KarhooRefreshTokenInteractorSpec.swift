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
    private var mockTokenValidityWorker: MockTokenValidityWorker!

    override func setUp() {
        super.setUp()
        MockSDKConfig.authenticationMethod = .tokenExchange(settings: MockSDKConfig.tokenExchangeSettings)
        mockUserDataStore = MockUserDataStore()
        mockRequestSender = MockRefreshTokenRequest()
        mockTokenValidityWorker = MockTokenValidityWorker()

        buildTestObject()
    }

    override class func tearDown() {
        super.tearDown()
        MockSDKConfig.authenticationMethod = .tokenExchange(settings: MockSDKConfig.tokenExchangeSettings)
    }

    /**
      * When: Requesting token
      * Then: Request should fire with expected path / method
      */
    func testRefreshRequest() {
        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture(), refreshTokenExpiryDate: dateInTheFarFuture())
        mockUserDataStore.credentialsToReturn = credentials
        mockTokenValidityWorker.tokenNeedsRefreshingToReturn = true
        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user

        testObject.refreshToken(completion: { _ in})

        mockRequestSender.assertRequestSend(endpoint: .authRefresh, method: .post)
    }

    /**
      * When: Requesting token (Auth settings)
      * And: Refresh token expiry is near future
      * Then: Require external authentication should be called
      */
    func testAuthRefreshRequest() {
        let expectation = XCTestExpectation(description: "requireSDKAuthenticationCalled")
        MockSDKConfig.authenticationMethod = .tokenExchange(settings: MockSDKConfig.tokenExchangeSettings)
        MockSDKConfig.requireSDKAuthenticationCompletion = {
            expectation.fulfill()
        }
        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture(), refreshTokenExpiryDate: dateInTheNearFuture())
        mockUserDataStore.credentialsToReturn = credentials
        mockTokenValidityWorker.tokenNeedsRefreshingToReturn = true
        mockTokenValidityWorker.refreshTokenNeedsRefreshingToReturn = true
        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user

        testObject.refreshToken(completion: { _ in})

        wait(for: [expectation], timeout: 10)
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
     *  Given:  TokenRefreshNeedWorker calculated the token needs refreshing
     *   When:  tokenNeedsRefreshing method called
     *   Then:  It should return true
     */
    func testTokenDoesNeedRefreshing() {
        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture())
        mockUserDataStore.credentialsToReturn = credentials
        mockTokenValidityWorker.tokenNeedsRefreshingToReturn = true
        mockTokenValidityWorker.refreshTokenNeedsRefreshingToReturn = true
        
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
        let worker = KarhooTokenValidityWorker(dataStore: mockUserDataStore)
        buildTestObject(tokenValidityWorker: worker)

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

        let expectation = XCTestExpectation(description: "correct captured value")
        testObject.refreshToken { result in
            result.isSuccess() ? expectation.fulfill() : XCTFail("Result success value expected")
            expectation.fulfill()
        }
        
        XCTAssertFalse(mockRequestSender.requestCalled)
        wait(for: [expectation], timeout: 10)
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
        let worker = KarhooTokenValidityWorker(dataStore: mockUserDataStore)
        buildTestObject(tokenValidityWorker: worker)
        XCTAssertTrue(testObject.tokenNeedsRefreshing())
    }

    /**
     *  Given:  Refresh token not saved in user data store
     *    And:  Token expiration date in near future
     *   Then:  request new auth credentials called
     */
    func testMissingRefreshToken() {
        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user

        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture(),
                                                                 withRefreshToken: false)
        let expectation = XCTestExpectation(description: "new auth credentials requested")
        
        mockUserDataStore.credentialsToReturn = credentials
        buildTestObject(tokenValidityWorker: KarhooTokenValidityWorker())

        MockSDKConfig.requireSDKAuthenticationCompletion = {
            expectation.fulfill()
        }

        testObject.refreshToken { _ in
        }
        
        wait(for: [expectation], timeout: 10)
    }

    /**
     *  Given:  TokenRefreshNeedWorker calculated the token needs refreshing
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
        mockTokenValidityWorker.tokenNeedsRefreshingToReturn = true

        let accessTokenAfterRefresh = TestUtil.getRandomString()
        let successResponse = AuthTokenMock().set(accessToken: accessTokenAfterRefresh).set(expiresIn: 10000)

        let expectation = XCTestExpectation(description: "correct captured value")
        testObject.refreshToken { result in
            result.isSuccess() ? expectation.fulfill() : XCTFail("Result success value expected")
        }

        mockRequestSender.success(response: successResponse.build())

        XCTAssertTrue(mockRequestSender.requestCalled)
        XCTAssertEqual(mockUserDataStore.storedCredentials?.accessToken, accessTokenAfterRefresh)
        
        wait(for: [expectation], timeout: 10)
    }

    /**
     *  Given:  Token needs refreshing
     *    And:  refreshToken method called
     *    And:  Network request is made to refresh token
     *   When:  Network request to refresh token fails
     *   Then:  New credentials should NOT be saved in user data store
     */
    func testRefreshTokenError() {
        let externalAuthRequestCalledExpectation = XCTestExpectation(description: "externalAuthRequestCalled")
        MockSDKConfig.requireSDKAuthenticationCompletion = {
            externalAuthRequestCalledExpectation.fulfill()
        }

        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user

        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture())
        mockUserDataStore.credentialsToReturn = credentials

        mockTokenValidityWorker.tokenNeedsRefreshingToReturn = true

        let expectedError = TestUtil.getRandomError()

        var capturedResult: Result<Bool>?
        testObject.refreshToken { result in
            capturedResult = result
        }

        mockRequestSender.fail(error: expectedError)

        XCTAssertTrue(mockRequestSender.requestCalled)
        wait(for: [externalAuthRequestCalledExpectation], timeout: 10)
    }

    /**
     *  Given:  Token needs refreshing
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
        mockTokenValidityWorker.tokenNeedsRefreshingToReturn = true
        mockTokenValidityWorker.refreshTokenNeedsRefreshingToReturn = false

        let accessTokenAfterRefresh = TestUtil.getRandomString()

        let requestPayload = AuthTokenMock().set(accessToken: accessTokenAfterRefresh).set(expiresIn: 10000)

        mockRequestSender.beforeResponse = { [weak self] in
            self?.mockUserDataStore.userToReturn = nil
        }

        let expectation = XCTestExpectation(description: "correct captured value")
        testObject.refreshToken { result in
            !result.isSuccess() ? expectation.fulfill() : XCTFail("Result failure expected")
            let expectedError = RefreshTokenError.userAlreadyLoggedOut
            let capturedError = result.getErrorValue() as? RefreshTokenError
            XCTAssertNotNil(capturedError)
            XCTAssertEqual(expectedError, capturedError)
            expectation.fulfill()
        }

        mockRequestSender.success(response: requestPayload.build())
        XCTAssertTrue(mockRequestSender.requestCalled)
        XCTAssert(mockUserDataStore.setCurrentUserCalled == false)
        wait(for: [expectation], timeout: 10)
    }

    /**
        When: at least two refresh request are made
        And: Refresh logic is done with any result
        Then: All refresh compltions should be triggered
     */
    func testMultipleRefreshRequestHandling() {
        let request1CompletionCalledExpectation = XCTestExpectation()
        let request2CompletionCalledExpectation = XCTestExpectation()

        let credentials = ObjectTestFactory.getRandomCredentials(expiryDate: dateInTheNearFuture())
        mockUserDataStore.credentialsToReturn = credentials

        testObject.refreshToken { _ in
            request1CompletionCalledExpectation.fulfill()
        }
        testObject.refreshToken { _ in
            request2CompletionCalledExpectation.fulfill()
        }
        
        let accessTokenAfterRefresh = TestUtil.getRandomString()
        let requestPayload = AuthTokenMock().set(accessToken: accessTokenAfterRefresh).set(expiresIn: 10000)
        mockRequestSender.success(response: requestPayload.build())

        wait(for: [request1CompletionCalledExpectation, request2CompletionCalledExpectation], timeout: 10)
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

        let expectation = XCTestExpectation(description: "correct captured value")
        testObject.refreshToken { result in
            result.isSuccess() ? expectation.fulfill() : XCTFail("Result success value expected")
            XCTAssertFalse(self.mockUserDataStore.setCurrentUserCalled)
            expectation.fulfill()
        }

        mockRequestSender.success(response: requestPayload.build())
        wait(for: [expectation], timeout: 10)
    }

    private func dateInTheFarFuture() -> Date {
        return TestUtil.getRandomDate(laterThan: Date().addingTimeInterval(3600))
    }

    private func dateInTheNearFuture() -> Date {
        let shortInterval = TimeInterval(Double(TestUtil.getRandomInt(lessThan: 60)) * 0.01)
        return Date().addingTimeInterval(shortInterval)
    }

    private func dateInThePast() -> Date {
        return Date().addingTimeInterval(-400)
    }

    private func buildTestObject(
        dataStore: UserDataStore? = nil,
        refreshTokenRequest: RequestSender? = nil,
        tokenValidityWorker: TokenValidityWorker? = nil
    ) {
        testObject = KarhooRefreshTokenInteractor(
            dataStore: dataStore ?? mockUserDataStore,
            refreshTokenRequest: refreshTokenRequest ?? mockRequestSender,
            tokenValidityWorker: tokenValidityWorker ?? mockTokenValidityWorker
        )
    }
}
