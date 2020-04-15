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

    private var testObject: KarhooAuthLoginInteractor!
    private var mocktokenExchangeRequest: MockRequestSender!
    private var mockUserRequest: MockRequestSender!
    private var mockUserDataStore: MockUserDataStore!
    private var mockAnalytics: MockAnalyticsService!
    
    override func setUp() {
        super.setUp()
        
        mocktokenExchangeRequest = MockRequestSender()
        mockAnalytics = MockAnalyticsService()
        mockUserRequest = MockRequestSender()
        mockUserDataStore = MockUserDataStore()
        mockAnalytics = MockAnalyticsService()
    
        testObject = KarhooAuthLoginInteractor(tokenExchangeRequestSender: mocktokenExchangeRequest,
                                               userInfoSender: mockUserRequest,
                                               userDataStore: mockUserDataStore,
                                               analytics: mockAnalytics)
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
        XCTAssertEqual("Bob", mockUserDataStore.updateUser?.firstName)
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
}
