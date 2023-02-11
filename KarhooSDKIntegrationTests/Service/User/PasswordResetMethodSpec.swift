//
//  PasswordResetMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class PasswordResetMethodSpec: XCTestCase {

    private var userService: UserService!
    private let path = "/v1/directory/users/password-reset"
    private var call: Call<KarhooVoid>!

    override func setUp() {
        super.setUp()

        userService = Karhoo.getUserService()

        call = userService.passwordReset(email: "some@some.com")
    }

    /**
      * Given: Resetting password
      * When: The request succeeds
      * Then: success result should be propogated
      */
    func testHappyPath() {
        NetworkStub.emptySuccessResponse(path: self.path)

        let expectation = self.expectation(description: "Calls callback with success result")
        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Resetting password
     * When: The request fails
     * Then: error result should be propogated
     */
    func testErrorResponse() {
        NetworkStub.errorResponse(path: self.path, responseData: RawKarhooErrorFactory.buildError(code: "K1006"))

        let expectation = self.expectation(description: "Calls callback with error result")
        call.execute(callback: { result in
            XCTAssertEqual(.couldNotGetUserDetails, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Resetting password
     * When: The request fails and the error response is invalid
     * Then: Unknown error should be propogated
     */
    func testErrorInvalidResponse() {
        NetworkStub.responseWithInvalidData(path: self.path, statusCode: 400)

        let expectation = self.expectation(description: "Calls callback with error")
        call.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Resetting password
     * When: The request times out
     * Then: Result is unknown error
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: path)

        let expectation = self.expectation(description: "calls the callback with error")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }
}
