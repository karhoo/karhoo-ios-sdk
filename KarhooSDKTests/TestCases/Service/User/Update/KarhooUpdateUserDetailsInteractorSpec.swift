//
//  KarhooUserUpdateProfileInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooUpdateUserDetailsInteractorSpec: XCTestCase {
    
    private var testObject: KarhooUpdateUserDetailsInteractor!
    private var mockUpdateSender: MockRequestSender!
    private var mockUserDataStore = MockUserDataStore()
    private var mockAnalytics = MockAnalyticsService()

    private var testUserProfileUpdate: UserDetailsUpdateRequest {
        return UserDetailsUpdateRequest(firstName: "FirstName",
                                        lastName: "Karhoo",
                                        phoneNumber: "0w0",
                                        locale: "locale",
                                        avatarURL: "avatar")
    }

    override func setUp() {
        super.setUp()
        mockUpdateSender = MockRequestSender()
        mockUserDataStore.userToReturn = UserInfoMock().set(userId: "some").build()
        testObject = KarhooUpdateUserDetailsInteractor(requestSender: mockUpdateSender,
                                                       userDataStore: mockUserDataStore,
                                                       analyticsService: mockAnalytics)
    }

    /**
    * When: sending request
    * Then: Expected payload and path should be set
    */
    func testUpdateFormat() {
        testObject.set(update: testUserProfileUpdate)
        testObject.execute(callback: { (_: Result<UserInfo>) -> Void in})
            mockUpdateSender.assertRequestSendAndDecoded(endpoint: .userProfileUpdate(identifier: "some"),
                                                         method: .put,
                                                         payload: testUserProfileUpdate)
    }
    
    /**
    * When: Update request succeeds
    * Then: expected callback should be propogated
    * And: New user should be persisted
    */
    func testUpdateSucceeds() {
        let expectedResult = UserInfoMock().set(userId: "some").build()

        var result: Result<UserInfo>?
        testObject.set(update: testUserProfileUpdate)
        testObject.execute(callback: { result = $0})

        mockUpdateSender.triggerSuccessWithDecoded(value: expectedResult)
        XCTAssertTrue(result!.isSuccess())
        XCTAssertEqual(expectedResult, result?.successValue())
        XCTAssertTrue(mockUserDataStore.updateUserCalled)
        XCTAssertEqual(mockUserDataStore.updateUser?.userId, expectedResult.userId)
        XCTAssertEqual(mockAnalytics.eventSent, AnalyticsConstants.EventNames.userProfileUpdateSuccess)
    }

        /**
        * When: update request fails
        * Then: expected callback should be propogated
        * And:  user data store should not update any user
        */
        func testUdpateFails() {
            let expectedError = TestUtil.getRandomError()

            var result: Result<UserInfo>?
            testObject.set(update: testUserProfileUpdate)
            testObject.execute(callback: { result = $0})

            mockUpdateSender.triggerFail(error: expectedError)

            XCTAssertFalse(result!.isSuccess())
            XCTAssertFalse(mockUserDataStore.updateUserCalled)
            XCTAssert(expectedError.equals(result!.errorValue()))
        }
}
