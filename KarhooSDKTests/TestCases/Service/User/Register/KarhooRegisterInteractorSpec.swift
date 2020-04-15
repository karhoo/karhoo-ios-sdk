//
//  KarhooRegisterInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooRegisterInteractorSpec: XCTestCase {

    private var testObject: KarhooRegisterInteractor!
    private var mockUserRegisterRequest: MockRequestSender!

    private var testUserRegistration: UserRegistration {
        return UserRegistration(firstName: "first",
                                lastName: "last",
                                email: "email",
                                phoneNumber: "phone",
                                locale: "locale",
                                password: "password")
    }

    override func setUp() {
        super.setUp()
        mockUserRegisterRequest = MockRequestSender()
        testObject = KarhooRegisterInteractor(requestSender: mockUserRegisterRequest)
    }

    /**
      * When: sending request
      * Then: Expected payload and path should be set
      */
    func testRequestFormat() {
        testObject.set(userRegistration: testUserRegistration)
        testObject.execute(callback: { (_: Result<UserInfo>) -> Void in})

        mockUserRegisterRequest.assertRequestSendAndDecoded(endpoint: .register,
                                                            method: .post,
                                                            payload: testUserRegistration)
    }

    /**
     * When: Sign up request succeeds
     * Then: expected callback should be propogated
     */
    func testRequestSucceeds() {
        let expectedResult = UserInfoMock().set(userId: "some").build()

        var result: Result<UserInfo>?
        testObject.set(userRegistration: testUserRegistration)
        testObject.execute(callback: { result = $0})

        mockUserRegisterRequest.triggerSuccessWithDecoded(value: expectedResult)
        XCTAssertTrue(result!.isSuccess())
        XCTAssertEqual(expectedResult, result?.successValue())
    }

    /**
     * When: Sign up request fais
     * Then: expected callback should be propogated
     */
    func testRequestFails() {
        let expectedError = TestUtil.getRandomError()

        var result: Result<UserInfo>?
        testObject.set(userRegistration: testUserRegistration)
        testObject.execute(callback: { result = $0})

        mockUserRegisterRequest.triggerFail(error: expectedError)

        XCTAssertFalse(result!.isSuccess())
        XCTAssert(expectedError.equals(result!.errorValue()))
    }
}
