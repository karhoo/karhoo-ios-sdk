//
//  KarhooUserServiceSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

final class KarhooUserServiceSpec: XCTestCase {

    private var mockUserDataStore: MockUserDataStore!
    private var mockRegisterInteractor: MockRegisterInteractor!
    private var mockLogoutInteractor: MockLogoutInteractor!
    private var mockPasswordResetInteractor: MockPasswordResetInteractor!
    private var mockUpdateUserDetailsInteractor: MockUpdateuserDetailsInteractor!

    private var testObject: UserService!

    override func setUp() {
        super.setUp()

        mockUserDataStore = MockUserDataStore()
        mockRegisterInteractor = MockRegisterInteractor()
        mockLogoutInteractor = MockLogoutInteractor()
        mockPasswordResetInteractor = MockPasswordResetInteractor()
        mockUpdateUserDetailsInteractor = MockUpdateuserDetailsInteractor()

        testObject = KarhooUserService(userDataStore: mockUserDataStore,
                                       registerInteractor: mockRegisterInteractor,
                                       passwordResetInteractor: mockPasswordResetInteractor,
                                       logoutInteractor: mockLogoutInteractor,
                                       updateUserDetailsInteractor: mockUpdateUserDetailsInteractor)
    }

    /**
     *  Given:  A logout attempt has been made
     *  When:   The logout attempt succeeds
     *  Then:   It should pass the information along to the caller
     */
    func testLogoutSuccessResponse() {
        var result: Result<KarhooVoid>?
        testObject.logout().execute(callback: { result = $0 })

        mockLogoutInteractor.triggerSuccess(result: KarhooVoid())

        XCTAssertTrue(result?.isSuccess() == true)
    }

    /**
     *  Given:  A logout attempt has been made
     *  When:   The logout attempt fails
     *  Then:   It should pass the error along to the caller
     */
    func testLogoutErrorResponse() {
        var result: Result<KarhooVoid>?
        testObject.logout().execute(callback: { result = $0 })

        let expectedError = TestUtil.getRandomError()
        mockLogoutInteractor.triggerFail(error: expectedError)

        XCTAssertFalse(result!.isSuccess())
        XCTAssert(expectedError.equals(result!.getErrorValue()))
    }

    /**
     *  Given:  No logged in user
     *  When:   Getting the current user
     *  Then:   It should pass nil to the caller
     */
    func testNoLoggedInUser() {
        let user = testObject.getCurrentUser()
        XCTAssertNil(user)
    }

    /**
     *  Given:  A logged in user
     *  When:   Getting the current user
     *  Then:   It should pass the user to the caller
     */
    func testLoggedInUser() {
        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user

        let returnedUser = testObject.getCurrentUser()
        XCTAssertEqual(user, returnedUser)
    }

    /**
     *  When:   Adding a observer
     *  Then:   The observer should be added to the data store
     */
    func testAddingObserver() {
        let observer = TestObserver()
        testObject.add(observer: observer)

        XCTAssert(mockUserDataStore.addedObserver === observer)
    }

    /**
     *  When:   Removing a observer
     *  Then:   The observer should be removed from the data store
     */
    func testRemovingObserver() {
        let observer = TestObserver()
        testObject.remove(observer: observer)

        XCTAssert(mockUserDataStore.removedObserver === observer)
    }
}

private class TestObserver: UserStateObserver {
    func userStateUpdated(user: UserInfo?) {}
}
