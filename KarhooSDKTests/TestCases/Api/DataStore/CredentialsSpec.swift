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

        let credentials = Credentials(accessToken: accessToken,
                                      expiresIn: expiresIn,
                                      refreshToken: refreshToken)

        XCTAssert(credentials.accessToken == accessToken)
        XCTAssert(credentials.refreshToken == refreshToken)

        let expectedExpiryDate = Date().addingTimeInterval(expiresIn)
        XCTAssert(TestUtil.datesEqual(credentials.expiryDate!, expectedExpiryDate))
    }

    /**
     *  When:   Converting from RefreshToken to Credentials
     *  Then:   ExpiryDate should be set correctly
     *   And:   Other fields should be set accordingly
     */
    func testInitialiseFromRestRefreshTokenResponse() {
        let accessToken = TestUtil.getRandomString()
        let expiresIn = TestUtil.getRandomInt()
        let refreshToken = TestUtil.getRandomString()
        let refreshTokenModel = RefreshToken(accessToken: accessToken, expiresIn: expiresIn)

        let credentials = refreshTokenModel.toCredentials(withRefreshToken: refreshToken)

        XCTAssert(credentials.accessToken == accessToken)
        XCTAssert(credentials.refreshToken == refreshToken)

        let expectedExpiryDate = Date().addingTimeInterval(TimeInterval(expiresIn))
        XCTAssert(TestUtil.datesEqual(credentials.expiryDate, expectedExpiryDate))
    }
}
