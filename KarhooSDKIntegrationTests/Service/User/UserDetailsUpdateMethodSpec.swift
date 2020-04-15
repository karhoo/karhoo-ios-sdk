//
//  UserDetailsUpdateMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  Created by Edward Wilkins on 23/09/2019.
//  Copyright © 2019 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class UserDetailsUpdateMethodSpec: XCTestCase {
    
    private var userService: UserService = Karhoo.getUserService()
    private let path = "/v1/directory/users/some_userId"
    private let authPath = "/v1/auth/token"
    private let profilePath = "/v1/directory/users/me"
    private var call: Call<UserInfo>!

    override func setUp() {
        super.setUp()
        login()
        let updateChanges = UserDetailsUpdateRequest(firstName: "BeLikeJeeves",
                                                     lastName: "Karhoolians",
                                                     phoneNumber: "7894 052433",
                                                     locale: nil,
                                                     avatarURL: nil)
        
        call = userService.updateUserDetails(update: updateChanges)
    }
    
    private func login() {
        NetworkStub.successResponse(jsonFile: "AuthToken.json", path: self.authPath)
        NetworkStub.successResponse(jsonFile: "AuthorisedUserInfo.json", path: self.profilePath)
        
        let expectation = self.expectation(description: "login finishes")
        userService.login(userLogin: UserLogin(username: "some", password: "some")).execute(callback: { _ in
            expectation.fulfill()
        })
    }

    /**
     Given: Updating Profile
     When: The request succeeds
     Then: Success result should be propogated
     */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "UpdateUserRequest.json", path: path)
        
        let expectation = self.expectation(description: "Calls callback with success result")
        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
    
    /**
     Given: Updating Profile
     When: The request fails
     Then: Failure result should be propogated
     */
    func testErrorResponse() {
        NetworkStub.errorResponse(path: path, responseData: RawKarhooErrorFactory.buildError(code: "K1006"))
        
        let expectation = self.expectation(description: "Calls callback with error result")
        call.execute(callback: { result in
            XCTAssertEqual(.couldNotGetUserDetails, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
    
    /**
     Given: Updating Profile
     When: The request fails and the error response is invalid
     Then: Unknown Error should be propogated
     */
    func testErrorInvalidResponse() {
        NetworkStub.responseWithInvalidData(path: self.path, statusCode: 400)
        
        let expectation = self.expectation(description: "Calls callback with error")
        call.execute(callback: { result in
            XCTAssertEqual(.missingUserPermission, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
    
    /**
     Given: Updaitng Profile
     When: The request times out
     Then: Result is unknown error
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: path)
        
        let expectation = self.expectation(description: "calls the callback with error")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
}
