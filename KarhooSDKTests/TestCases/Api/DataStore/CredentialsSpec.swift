//
//  CredentialsSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class CredentialsSpec: XCTestCase {

    /**
     *  When:   Creating Credentials object using convenience init
     *  Then:   expectedDate should be correct
     */
    func testCredentialsConvenienceInit() {
        let expiresIn: TimeInterval = 1000

        let accessToken = TestUtil.getRandomString()
        let refreshToken = TestUtil.getRandomString()

        let credentials = Credentials(
            accessToken: accessToken,
            expiresIn: expiresIn,
            refreshToken: refreshToken,
            refreshTokenExpiresIn: expiresIn
        )

        XCTAssert(credentials.accessToken == accessToken)
        XCTAssert(credentials.refreshToken == refreshToken)

        let expectedExpiryDate = Date().addingTimeInterval(expiresIn)
        XCTAssert(TestUtil.datesEqual(credentials.expiryDate!, expectedExpiryDate))
    }
}
