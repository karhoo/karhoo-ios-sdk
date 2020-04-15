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
    private var mockLoginInteractor: MockLoginInteractor!
    private var mockUpdateUserDetailsInteractor: MockUpdateuserDetailsInteractor!

    private var testObject: UserService!

    override func setUp() {
        super.setUp()

        mockUserDataStore = MockUserDataStore()
        mockRegisterInteractor = MockRegisterInteractor()
        mockLogoutInteractor = MockLogoutInteractor()
        mockPasswordResetInteractor = MockPasswordResetInteractor()
        mockLoginInteractor = MockLoginInteractor()
        mockUpdateUserDetailsInteractor = MockUpdateuserDetailsInteractor()

        testObject = KarhooUserService(userDataStore: mockUserDataStore,
                                       loginInteractor: mockLoginInteractor,
                                       registerInteractor: mockRegisterInteractor,
                                       passwordResetInteractor: mockPasswordResetInteractor,
                                       logoutInteractor: mockLogoutInteractor,
                                       updateUserDetailsInteractor: mockUpdateUserDetailsInteractor)
    }

    /**
     *  Given:  A email and password
     *  When:   Trying to log in
     *  Then:   It should request a login from the login data accessor
     */
    func testLogin() {
        let userLogin = UserLogin(username: "name", password: "password")
        testObject.login(userLogin: userLogin).execute(callback: { _ in})

        XCTAssertEqual(userLogin.encode(), mockLoginInteractor.userLoginSet?.encode())
    }

    /**
     *  Given:  A login attempt has been made
     *  When:   The login attempt succeeds
     *  Then:   It should pass the information along to the caller
     */
    func testLoginSuccessful() {
        var returnedUser: UserInfo?
        let userLogin = UserLogin(username: "some", password: "some")
        testObject.login(userLogin: userLogin).execute(callback: { (result: Result<UserInfo>) in
            returnedUser = result.successValue()
        })

        let user = UserInfoMock().set(userId: "some").build()
        mockLoginInteractor.triggerSuccess(result: user)

        XCTAssertEqual(user.encode(), returnedUser?.encode())
    }

    /**
     *  Given:  A login attempt has been made
     *  When:   The login attempt fails
     *  Then:   It should pass the error along to the caller
     */
    func testLoginFailure() {
        let expectedError = TestUtil.getRandomError()

        let userLogin = UserLogin(username: "some", password: "some")
        var result: Result<UserInfo>?
        testObject.login(userLogin: userLogin)
                  .execute(callback: { result = $0 })

        mockLoginInteractor.triggerFail(error: expectedError)
        XCTAssert(expectedError.equals(result!.errorValue()))
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
        XCTAssert(expectedError.equals(result!.errorValue()))
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
     *  When:   Attempting to create a user
     *  Then:   The sign up service should be called with the correct arguments
     */
    func testRegister() {
        let userRegistration = UserRegistrationMock().build()
        let successMock = UserInfoMock().set(userId: "some").build()

        var registerResult: Result<UserInfo>?
        testObject.register(userRegistration: userRegistration)
            .execute(callback: { registerResult = $0 })

        XCTAssertEqual(userRegistration.encode(), mockRegisterInteractor.userRegistrationSet?.encode())

        mockRegisterInteractor.triggerSuccess(result: successMock)

        XCTAssertEqual(successMock, registerResult?.successValue())
    }

    /**
     *  Given:  Resetting password
     *  When:   PasswordResetInteractor succeeds
     *  Then:   Expected callback should be propagated
     */
    func testPasswordResetSuccess() {
        var passwordResult: Result<KarhooVoid>?
        testObject.passwordReset(email: "some")
            .execute(callback: { passwordResult = $0 })

        mockPasswordResetInteractor.triggerSuccess(result: KarhooVoid())
        XCTAssertTrue(passwordResult!.isSuccess())
    }

    /**
      *  Given:  Resetting password
      *  When:   PasswordResetInteractor fails
      *  Then:   Expected callback should be propagated
      */
    func testPasswordResetFails() {
        let testError = TestUtil.getRandomError()

        var result: Result<KarhooVoid>?
        testObject.passwordReset(email: "some")
            .execute(callback: { result = $0 })

        mockPasswordResetInteractor.triggerFail(error: testError)

        XCTAssertFalse(result!.isSuccess())
        XCTAssert(testError.equals(result!.errorValue()))
    }
    
    /**
     *  Given: Updating Profile
     *  When: UpdateUserDetailsInteractor succeeds
     *  Then: The updated details should be sent
     */
    func testUpdateUserDetailsSuccess() {
        let request = UserUpdateMock().set(firstName: "FirstName").build()
        let response = UserInfoMock().set(firstName: "Response").build()
        var updateResult: Result<UserInfo>?
        
        testObject.updateUserDetails(update: request)
            .execute(callback: { updateResult = $0 })
        
        mockUpdateUserDetailsInteractor.triggerSuccess(result: response)
        XCTAssertTrue(updateResult!.isSuccess())
        XCTAssertEqual(updateResult?.successValue()?.firstName, "Response")
    }

    /**
     *  Given: Updating Profile
     *  When: UpdateUserDetailsInteractor fails
     *  Then: Error should be sent
     */
    func testUpdateUserDetailsFails() {
        let request = UserUpdateMock().set(firstName: "FirstName").build()
        let expectedError = TestUtil.getRandomError()
        var updateResult: Result<UserInfo>?
        
        testObject.updateUserDetails(update: request)
            .execute(callback: { updateResult = $0 })
        
        mockUpdateUserDetailsInteractor.triggerFail(error: expectedError)
        XCTAssertFalse(updateResult!.isSuccess())
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
