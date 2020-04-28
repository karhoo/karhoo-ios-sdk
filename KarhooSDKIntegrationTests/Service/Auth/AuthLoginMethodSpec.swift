//
//  AuthLoginMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class AuthLoginMethodSpec: XCTestCase {
    private var authService: AuthService!
    private let exchangeTokenPath = "/karhoo/anonymous/token-exchange"
    private let userInfoPath = "/oauth/v2/userinfo"
    
    private var call: Call<UserInfo>!
    
    override func setUp() {
        super.setUp()
        MockSDKConfig.authenticationMethod = .tokenExchange(settings: MockSDKConfig.tokenExchangeSettings)
        authService = Karhoo.getAuthService()
        call = authService.login(token: "aasdasdadqdqwd")
    }
    
    /**
      * Given: Calling SSO auth login with client id = mobile-accor
      * And: The access code is returned
      * And: The access token is generated using the code
      * Then: The userInfo is returned via the access token
      */
    func testUserLoginSuccess() {
        NetworkStub.successResponse(jsonFile: "AuthExchangeToken.json", path: exchangeTokenPath)
        NetworkStub.successResponse(jsonFile: "AuthUserInfo.json", path: userInfoPath)
       
        let expectation = self.expectation(description: "Calls callback with expected result")
        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.5)
    }
    
    /**
      * Given: Calling SSO auth login with client id = mobile-accor
      * And: The access code is not returned
      * Then: The user is not logged
      */
    func testUserLoginAuthCodeFail() {
        NetworkStub.errorResponse(path: exchangeTokenPath, responseData: RawKarhooErrorFactory.buildError(code: "K9999"))
    
        let expectation = self.expectation(description: "Calls callback with expected result")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
    
    /**
      * Given: Calling SSO auth login with client id = mobile-accor
      * And: The access code is returned but with invalid data
      * Then: The user is not logged
      */
    func testUserLoginAuthCodeInvalid() {
        NetworkStub.responseWithInvalidData(path: exchangeTokenPath, statusCode: 200)
        
        let expectation = self.expectation(description: "Calls callback with expected result")
        call.execute(callback: { result in
            XCTAssertNil(result.successValue()?.userId)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
    
    /**
      * Given: Calling SSO auth login with client id = mobile-accor
      * And: The access code is returned
      * And: The access token request fails
      * Then: The user is not logged
      */
    func testUserLoginAuthTokenFail() {
        NetworkStub.successResponse(jsonFile: "AuthExchangeToken.json", path: exchangeTokenPath)
        NetworkStub.errorResponse(path: exchangeTokenPath, responseData: RawKarhooErrorFactory.buildError(code: "K9999"))
        
        let expectation = self.expectation(description: "Calls callback with expected result")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
    
    /**
      * Given: Calling SSO auth login with client id = mobile-accor
      * And: The access code is returned
      * And: The access token request response is invalid
      * Then: The user is not logged
      */
    func testUserLoginAuthTokenInvalid() {
        NetworkStub.successResponse(jsonFile: "AuthExchangeToken.json", path: exchangeTokenPath)
        NetworkStub.responseWithInvalidData(path: exchangeTokenPath, statusCode: 401)
        
        let expectation = self.expectation(description: "Calls callback with expected result")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.5)
    }
    
    /**
      * Given: Calling SSO auth login with client id = mobile-accor
      * And: The access code is returned
      * And: The access token request is successfull
      * Then: The userInfo request fails
      */
    func testUserLoginUserInfoFail() {
        NetworkStub.successResponse(jsonFile: "AuthExchangeToken.json", path: exchangeTokenPath)
        NetworkStub.errorResponse(path: userInfoPath, responseData: RawKarhooErrorFactory.buildError(code: "K9999"))
        
        let expectation = self.expectation(description: "Calls callback with expected result")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
    
    /**
      * Given: Calling SSO auth login with client id = mobile-accor
      * And: The access code is returned
      * And: The access token request is successfull
      * Then: The userInfo return value is invalid
      */
    func testUserLoginUserInfoInvalid() {
        NetworkStub.successResponse(jsonFile: "AuthExchangeToken.json", path: exchangeTokenPath)
        NetworkStub.responseWithInvalidData(path: userInfoPath, statusCode: 200)

        let expectation = self.expectation(description: "Calls callback with expected result")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
}
