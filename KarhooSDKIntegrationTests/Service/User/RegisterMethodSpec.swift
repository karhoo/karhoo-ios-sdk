//
//  RegisterMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class RegisterMethodSpec: XCTestCase {

    private var userService: UserService!
    private let path = "/v1/directory/users"
    private var call: Call<UserInfo>!

    override func setUp() {
        super.setUp()

        self.userService = Karhoo.getUserService()
        let userRegistration = UserRegistration(firstName: "", lastName: "", email: "",
                                                phoneNumber: "", locale: nil, password: "")
        self.call = userService.register(userRegistration: userRegistration)
    }

    /**
     * When: Registering user
     * And: The response returns location info json object
     * Then: Result is success and returns LocationInfo object
     */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "AuthorisedUserInfo.json", path: path)

        let expectation = self.expectation(description: "calls the callback with success")

        call.execute(callback: { [weak self] result in
            XCTAssertTrue(result.isSuccess())
            self?.assertUserInfo(info: result.successValue()!)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.75, handler: .none)
    }

    /**
     * When: Registering user
     * And: The response returns an error
     * Then: Result is error
     */
    func testErrorResponse() {
        let expectedError = RawKarhooErrorFactory.buildError(code: "K1001")

        NetworkStub.errorResponse(path: path, responseData: expectedError)

        let expectation = self.expectation(description: "calls the callback with error")

        call.execute(callback: { result in
            let error = result.errorValue()
            XCTAssertEqual(.couldNotRegister, error?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.75, handler: .none)
    }

    /**
     * When: Registering user
     * And: The response returns empty json object
     * Then: Result is success with empty LocationInfo object
     */
    func testEmptyResponse() {
        NetworkStub.emptySuccessResponse(path: path)

        let expectation = self.expectation(description: "calls the callback with success")

        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.75, handler: .none)
    }

    /**
     * When: Registering user
     * And: The response returns invalid json object
     * Then: Result is error
     */
    func testInvalidResponse() {
        NetworkStub.responseWithInvalidJson(path: path, statusCode: 200)

        let expectation = self.expectation(description: "calls the callback with error")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.75, handler: .none)
    }

    /**
     * When: Registering user
     * And: The response returns time out error
     * Then: Result is error
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: path)

        let expectation = self.expectation(description: "calls the callback with error")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.75, handler: .none)
    }

    private func assertUserInfo(info: UserInfo) {
        XCTAssertEqual("some_userId", info.userId)
        XCTAssertEqual("Some", info.firstName)
        XCTAssertEqual("SomeSome", info.lastName)
        XCTAssertEqual("some@email.com", info.email)
        XCTAssertEqual("12345678910", info.mobileNumber)
        XCTAssertEqual("string", info.locale)
        XCTAssertEqual("", info.metadata)
    }
}
