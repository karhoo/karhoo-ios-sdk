//
//  TokenRefreshingHttpClientSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class TokenRefreshingHttpClientSpec: XCTestCase {

    private var mockHttpClient: MockHttpClient!
    private var testRefreshTokenProvider: TestRefreshTokenProvider!
    private var mockUserDataStore: MockUserDataStore!
    private var testObject: TokenRefreshingHttpClient!

    override func setUp() {
        super.setUp()

        mockHttpClient = MockHttpClient()
        testRefreshTokenProvider = TestRefreshTokenProvider()
        mockUserDataStore = MockUserDataStore()

        testObject = TokenRefreshingHttpClient(httpClient: mockHttpClient,
                                               refreshTokenProvider: testRefreshTokenProvider,
                                               dataStore: mockUserDataStore)
    }

    /**
     *  Given:  Access token does NOT need refreshing
     *   When:  Sending a request
     *   Then:  Request should be send immediately
     *    And:  Request send from httpClient should be returned
     */
    func testTokenDoesNotNeedRefreshingSendRequest() {
        testRefreshTokenProvider.tokenNeedsRefreshingValueToReturn = false
        let mockNetworkRequest = MockNetworkRequest()
        mockHttpClient.networkRequestToReturn = mockNetworkRequest

        var capturedResult: Result<HttpResponse>?
        let capturedRequest = testObject.sendRequest(endpoint: .bookTrip) { result in
            capturedResult = result
        }

        let mockResult = HttpResponse(code: 200, data: Data())
        mockHttpClient.lastCompletion?(Result.success(result: mockResult))

        XCTAssert(mockHttpClient.sendRequestsCount == 1)
        XCTAssert(capturedRequest! as? MockNetworkRequest === mockNetworkRequest)
        XCTAssert(capturedResult?.isSuccess() == true)
    }

    /**
     *  Given:  Access token DOES need refreshing
     *   When:  Sending a request
     *   Then:  KarhooRefreshTokenInteractor should refresh token
     *    And:  HttpClient should send a request
     *    And:  AsyncNetworkRequestWrapper instance should be returned
     */
    func testTokenDoesNeedRefreshing() {
        testRefreshTokenProvider.tokenNeedsRefreshingValueToReturn = true
        let mockNetworkRequest = MockNetworkRequest()
        mockHttpClient.networkRequestToReturn = mockNetworkRequest

        let capturedRequest = testObject.sendRequest(endpoint: .bookTrip) { _ in }

        XCTAssertNotNil(capturedRequest)
        XCTAssertNotNil((capturedRequest as? AsyncNetworkRequestWrapper)?.hasRequest)
    }

    /**
     *  Given:  Access token DOES need refreshing
     *    And:  Sending a request
     *   When:  KarhooRefreshTokenInteractor token refresh succeeds
     *   Then:  Http client call should be made
     *    And:  Callback should be fired
     */
    func testTokenDoesNeedRefreshingRefreshSuccess() {
        testRefreshTokenProvider.tokenNeedsRefreshingValueToReturn = true
        let mockNetworkRequest = MockNetworkRequest()
        mockHttpClient.networkRequestToReturn = mockNetworkRequest

        var capturedResult: Result<HttpResponse>?
        let capturedRequest = testObject.sendRequest(endpoint: .bookTrip) { result in
                                                        capturedResult = result
        }

        testRefreshTokenProvider.capturedRefreshTokenCompletion?(Result.success(result: true))

        let mockResult = HttpResponse(code: 200, data: Data())
        mockHttpClient.lastCompletion?(Result.success(result: mockResult))

        XCTAssertNotNil(capturedRequest)
        XCTAssert(mockHttpClient.sendRequestsCount == 1)
        XCTAssert(capturedResult?.isSuccess() == true)
    }

    /**
     *  Given:  Access token DOES need refreshing
     *    And:  Sending a request
     *    And:  Returned NetworkRequest is cancelled
     *    And:  KarhooRefreshTokenInteractor token refresh succeeds
     *   When:  Refresh Token completes
     *   Then:  Http client call should NOT be made
     */
    func testTokenDoesNeedRefreshingRefreshSuccessRequestCancelled() {
        testRefreshTokenProvider.tokenNeedsRefreshingValueToReturn = true
        let mockNetworkRequest = MockNetworkRequest()
        mockHttpClient.networkRequestToReturn = mockNetworkRequest

        let capturedRequest = testObject.sendRequest(endpoint: .bookTrip) { _ in }

        capturedRequest?.cancel()
        testRefreshTokenProvider.capturedRefreshTokenCompletion?(Result.success(result: true))

        XCTAssert(testRefreshTokenProvider.refreshTokenCalled)
        XCTAssert(mockHttpClient.sendRequestsCount == 0)
    }

    /**
     *  Given:  Access token DOES need refreshing
     *    And:  Sending a request
     *    And:  Returned NetworkRequest is cancelled
     *    And:  KarhooRefreshTokenInteractor token refresh succeeds
     *    And:  Network request is made
     *    And:  Returned network request gets cancelled
     *   When:  Actual network request returns
     *   Then:  Completion block should NOT be called
     */
    func testTokenNeedsRefreshingSuccessNetworkRequestMadeAndCancelled() {
        testRefreshTokenProvider.tokenNeedsRefreshingValueToReturn = true
        let mockNetworkRequest = MockNetworkRequest()
        mockHttpClient.networkRequestToReturn = mockNetworkRequest

        let capturedRequest = testObject.sendRequest(endpoint: .bookTrip) { _ in }

        testRefreshTokenProvider.capturedRefreshTokenCompletion?(Result.success(result: true))

        capturedRequest?.cancel()
        XCTAssert(mockNetworkRequest.cancelCalled)
    }

    /**
     *  Given:  Access token DOES need refreshing
     *    And:  Sending a request
     *    And:  NO network connection
     *   When:  KarhooRefreshTokenInteractor token refresh failure
     *   Then:  Http client call should NOT be made
     *    And:  Failure Callback should be called with an error
     */
    func testTokenDoesNeedRefreshingRefreshFailureNoNetwork() {
        testRefreshTokenProvider.tokenNeedsRefreshingValueToReturn = true
        let mockNetworkRequest = MockNetworkRequest()
        mockHttpClient.networkRequestToReturn = mockNetworkRequest

        var capturedResult: Result<HttpResponse>?
        testObject.sendRequest(endpoint: .bookTrip) { result in
                                capturedResult = result
        }

        let noConnectionError = HTTPError(statusCode: 0, errorType: .notConnectedToInternet)
        let errorResult = Result<Bool>.failure(error: noConnectionError)
        testRefreshTokenProvider.capturedRefreshTokenCompletion?(errorResult)

        XCTAssert(mockHttpClient.sendRequestsCount == 0)
        XCTAssert(capturedResult?.isSuccess() == false)
        XCTAssertEqual(noConnectionError, capturedResult?.errorValue() as? HTTPError)
    }

    /**
     *  Given:  Access token DOES need refreshing
     *    And:  Sending a request
     *    And:  Network connection is up
     *   When:  KarhooRefreshTokenInteractor token refresh failure
     *   Then:  Http client call should be made
     *    And:  AsyncNetworkRequestWrapper instance should be returned
     *    And:  Callback should be called with refresh token error
     */
    func testTokenDoesNeedRefreshingRefreshFailureWithNetworkConnection() {
        testRefreshTokenProvider.tokenNeedsRefreshingValueToReturn = true
        let mockNetworkRequest = MockNetworkRequest()
        mockHttpClient.networkRequestToReturn = mockNetworkRequest

        var capturedResult: Result<HttpResponse>?
        let capturedRequest = testObject.sendRequest(endpoint: .bookTrip) { result in
                                                        capturedResult = result
        }

        let tokenError = TestUtil.getRandomError()
        let tokenRefreshErrorResult = Result<Bool>.failure(error: tokenError)
        testRefreshTokenProvider.capturedRefreshTokenCompletion?(tokenRefreshErrorResult)

        XCTAssertNotNil((capturedRequest as? AsyncNetworkRequestWrapper)?.hasRequest)
        XCTAssert(capturedResult?.isSuccess() == false)
        XCTAssert(tokenError.equals(capturedResult!.errorValue()!))
    }

    /**
     *  Given:  Access token does NOT need refreshing
     *    And:  Sending a network request
     *    And:  The response is 401 unauthorized error code
     *   When:  It tries to refresh token
     *    And:  Token refresh is successful
     *   Then:  It should retry making the request
     *    And:  Request result callback should be executed
     */
    func testSuccessfulTokenRefreshOn401() {
        testRefreshTokenProvider.tokenNeedsRefreshingValueToReturn = false
        mockHttpClient.networkRequestToReturn = MockNetworkRequest()

        var capturedResult: Result<HttpResponse>?
        testObject.sendRequest(endpoint: .bookTrip) { result in
                                capturedResult = result
        }

        testRefreshTokenProvider.refreshTokenResult = Result.success(result: true)
        XCTAssert(mockHttpClient.sendRequestsCount == 1)

        let unauthenticatedError = TestUtil.getUnauthenticatedError()
        mockHttpClient.lastCompletion?(Result.failure(error: unauthenticatedError))

        XCTAssert(mockHttpClient.sendRequestsCount == 2)
        mockHttpClient.lastCompletion?(Result.success(result: HttpResponse(code: 200, data: Data())))

        XCTAssert(testRefreshTokenProvider.tokenNeedsRefreshingCalled)
        XCTAssert(testRefreshTokenProvider.refreshTokenCalled)

        XCTAssert(capturedResult?.isSuccess() == true)
    }

    /**
     *  Given:  Access token does NOT need refreshing
     *    And:  Sending a network request
     *    And:  The response is 401 unauthorized error code
     *   When:  It tries to refresh token
     *    And:  Token refresh fails
     *   Then:  User should be logged out
     *    And:  Request result callback should be executed
     */
    func testTokenRefreshFailureOn401() {
        mockUserDataStore.storedUser = UserInfoMock().set(userId: "some").build()

        testRefreshTokenProvider.tokenNeedsRefreshingValueToReturn = false
        mockHttpClient.networkRequestToReturn = MockNetworkRequest()

        var capturedResult: Result<HttpResponse>?
        testObject.sendRequest(endpoint: .bookTrip) { result in
                                capturedResult = result
        }

        testRefreshTokenProvider.refreshTokenResult = Result.failure(error: TestUtil.getRandomError())
        XCTAssert(mockHttpClient.sendRequestsCount == 1)

        let unauthenticatedError = TestUtil.getUnauthenticatedError()
        mockHttpClient.lastCompletion?(Result.failure(error: unauthenticatedError))

        XCTAssert(mockHttpClient.sendRequestsCount == 1)
        let expectedError = TestUtil.getRandomError()
        mockHttpClient.lastCompletion?(Result.failure(error: expectedError))

        XCTAssert(testRefreshTokenProvider.tokenNeedsRefreshingCalled)
        XCTAssert(testRefreshTokenProvider.refreshTokenCalled)

        XCTAssert(expectedError.equals(capturedResult!.errorValue()!))

        XCTAssert(mockUserDataStore.removeUserCalled == true)
    }
}

private final class TestRefreshTokenProvider: RefreshTokenInteractor {

    private(set) var tokenNeedsRefreshingCalled = false
    var tokenNeedsRefreshingValueToReturn = false

    func tokenNeedsRefreshing() -> Bool {
        tokenNeedsRefreshingCalled = true
        return tokenNeedsRefreshingValueToReturn
    }

    private(set) var refreshTokenCalled = false
    var refreshTokenResult: Result<Bool>?

    var capturedRefreshTokenCompletion: ((Result<Bool>) -> Void)?

    func refreshToken(completion: @escaping (Result<Bool>) -> Void) {
        refreshTokenCalled = true
        capturedRefreshTokenCompletion = completion

        if let result = refreshTokenResult {
            completion(result)
        }
    }
}
