//
//  DefaultAuthTokenSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

final class DefaultAuthTokenProviderSpec: XCTestCase {

    private var mockUserDataStore: MockUserDataStore!
    private var testObject: DefaultAccessTokenProvider!

    override func setUp() {
        super.setUp()

        mockUserDataStore = MockUserDataStore()
        testObject = DefaultAccessTokenProvider(userStore: mockUserDataStore)
    }

    /**
     *  Given:  User credentials saved
     *  When:   Requesting authorization token
     *  Then:   Correct token value should be returned
     */
    func testTokenProvider() {
        let testToken = "Test token"
        mockUserDataStore.credentialsToReturn = Credentials(accessToken: testToken,
                                                            expiryDate: nil,
                                                            refreshToken: nil)

        let capturedToken = testObject.accessToken
        XCTAssert(capturedToken?.token == testToken)
    }

    /**
     *  Given:  User credentials NOT saved
     *  When:   Requesting authorization token
     *  Then:   Nil should be returned
     */
    func testMissingToken() {
        mockUserDataStore.credentialsToReturn = nil

        let capturedToken = testObject.accessToken
        XCTAssertNil(capturedToken)
    }
}
