//
//  LoginMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class LoginMethodSpec: XCTestCase {

    private var userService: UserService!
    private let authPath = "/v1/auth/token"
    private let profilePath = "/v1/directory/users/me"
    private let oauthUserInfoPath = "/oauth/v2/userInfo"

    private var call: Call<UserInfo>!

    override func setUp() {
        super.setUp()
        MockSDKConfig.authenticationMethod = .karhooUser
        
        userService = Karhoo.getUserService()
        tearDown()
        
        let userLogin = UserLogin(username: "some", password: "some")
        call = userService.login(userLogin: userLogin)
    }

    override func tearDown() {
        super.tearDown()
        userService.logout().execute(callback: { _ in})
    }

    /**
      * Given: Calling login
      * When: Auth token requests succeeds
      * And: profile request succeeds with an authorised user
      * Then: Expected result should be propogated
      */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "AuthToken.json", path: self.authPath)
        NetworkStub.successResponse(jsonFile: "AuthorisedUserInfo.json", path: self.profilePath)

        let expectation = self.expectation(description: "Calls callback with expected result")
        call.execute(callback: { result in
            XCTAssertEqual("some_userId", result.getSuccessValue()?.userId)
            XCTAssertEqual("", result.getSuccessValue()?.externalId)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }
    
    /**
     * Given: Calling login
     * When: Auth token requests fails
     * Then: Expected error should be propogated
     */
    func testAuthTokenRequestFailsWithError() {
        NetworkStub.errorResponse(path: self.authPath, responseData: RawKarhooErrorFactory.buildError(code: "K1011"))

        let expectation = self.expectation(description: "Calls callback with expected error")
        call.execute(callback: { result in
            XCTAssertEqual(.passwordInWrongFormat, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Calling login
     * When: Auth token requests succeeds
     * And: profile request fails
     * Then: Expected error should be propogated
     */
    func testAuthTokenSuccessProfileRequestFails() {
        NetworkStub.successResponse(jsonFile: "AuthToken.json", path: self.authPath)
        NetworkStub.errorResponse(path: self.profilePath, responseData: RawKarhooErrorFactory.buildError(code: "K1005"))

        let expectation = self.expectation(description: "Calls callback with expected error")
        call.execute(callback: { result in
            XCTAssertEqual(.couldNotGetUserDetails, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Calling login
     * When: Auth token requests succeeds
     * And: profile request succeeds
     * And: User is unauthorised (missing TRIP_ADMIN role)
     * Then: Missing permission error should be propogated
     */
    func testUnauthorisedLogin() {
        NetworkStub.successResponse(jsonFile: "AuthToken.json", path: self.authPath)
        NetworkStub.successResponse(jsonFile: "UnauthorisedUserInfo.json", path: self.profilePath)

        let expectation = self.expectation(description: "Calls callback with expected error")
        call.execute(callback: { result in
            XCTAssertEqual(.missingUserPermission, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Calling login
     * When: Auth token requests succeeds
     * And: profile request succeeds but response is invalid
     * Then: Unexpected error should be propogated
     */
    func testInvalidProfileResponse() {
        NetworkStub.successResponse(jsonFile: "AuthToken.json", path: self.authPath)
        NetworkStub.responseWithInvalidData(path: self.profilePath, statusCode: 200)

        let expectation = self.expectation(description: "Calls callback with expected error")
        call.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5)
    }

    /**
      * When: Logging in
      * And: The user is already logged in
      * Then: User already logged in error should be propagated
      */
    func testLoginWhenAlreadyLoggedIn() {
        NetworkStub.successResponse(jsonFile: "AuthToken.json", path: self.authPath)
        NetworkStub.successResponse(jsonFile: "AuthorisedUserInfo.json", path: self.profilePath)

        let initialLoginExpectation = self.expectation(description: "1st login attempt finished")
        let secondLoginExpectation = self.expectation(description: "2nd login attempt finished")

        call.execute(callback: { _ in
            initialLoginExpectation.fulfill()

            // login again
            self.call.execute(callback: { result in
                XCTAssertEqual(.userAlreadyLoggedIn, result.getErrorValue()?.type)
                secondLoginExpectation.fulfill()
            })
        })

        wait(for: [initialLoginExpectation, secondLoginExpectation], timeout: 10)
    }

    /**
     * Given: Logging in
     * When: The request times out
     * Then: Result is unknown error
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: authPath)

        let expectation = self.expectation(description: "calls the callback with error")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }
}
