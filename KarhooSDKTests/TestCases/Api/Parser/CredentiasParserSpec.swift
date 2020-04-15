//
//  CredentiasParserSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

class CredentiasParserSpec: XCTestCase {

    /**
     *  Given:  A correctly formate dictionary
     *  When:   Converting to SDK credentials
     *  Then:   The corresponding SDK credentials should be produced
     */
    func testConvertToCredentials() {
        let accessToken = TestUtil.getRandomString()
        let expiryDate = Date()
        let refreshToken = TestUtil.getRandomString()
        let dictionary = [CredentialsStoreKeys.accessToken.rawValue: accessToken,
                          CredentialsStoreKeys.expiryDate.rawValue: expiryDate,
                          CredentialsStoreKeys.refreshToken.rawValue: refreshToken] as [String: Any]

        let credentials = DefaultCredentialsParser().from(dictionary: dictionary)

        XCTAssert(credentials?.accessToken == accessToken)
        XCTAssert(credentials?.expiryDate == expiryDate)
        XCTAssert(credentials?.refreshToken == refreshToken)
    }

    /**
     *  Given:  A dictionary with no access token
     *  When:   Converting to SDK credentials
     *  Then:   The conversion should not produce anything
     */
    func testConvertInvalidDictionaryToCredentials() {
        let expiryDate = Date()
        let refreshToken = "blue"
        let dictionary = [CredentialsStoreKeys.expiryDate.rawValue: expiryDate,
                          CredentialsStoreKeys.refreshToken.rawValue: refreshToken] as [String: Any]

        let credentials = DefaultCredentialsParser().from(dictionary: dictionary)

        XCTAssertNil(credentials)
    }

    /**
     *  Given:  A nil dictionary
     *  When:   Converting to SDK credentials
     *  Then:   The conversion should not produce anything
     */
    func testNilDictionaryToCredentials() {
        let credentials = DefaultCredentialsParser().from(dictionary: nil)

        XCTAssertNil(credentials)
    }

    /**
     *  Given:  Credentials with access token set
     *  When:   Converting to a dictionary
     *  Then:   The corresponding dictionary should be produced
     */
    func testConvertCredentialsToDictionary() {
        let accessToken = TestUtil.getRandomString()
        let expiryDate = Date()
        let refreshToken = TestUtil.getRandomString()
        let credentials = Credentials(accessToken: accessToken,
                                      expiryDate: expiryDate,
                                      refreshToken: refreshToken)

        let dictionary = DefaultCredentialsParser().from(credentials: credentials)

        XCTAssert(dictionary?[CredentialsStoreKeys.accessToken.rawValue] as? String == accessToken)
        XCTAssert(dictionary?[CredentialsStoreKeys.expiryDate.rawValue] as? Date == expiryDate)
        XCTAssert(dictionary?[CredentialsStoreKeys.refreshToken.rawValue] as? String == refreshToken)
    }

    /**
     *  Given:  Nil credentials
     *  When:   Converting to a dictionary
     *  Then:   The conversion should not produce anything
     */
    func testNilCredentialsToDictionary() {
        let dictionary = DefaultCredentialsParser().from(credentials: nil)

        XCTAssertNil(dictionary)
    }
}
