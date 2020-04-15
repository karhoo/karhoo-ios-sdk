//
//  KarhooLogoutInteractorSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

final class KarhooLogoutInteractorSpec: XCTestCase {

    private var mockAnalytics: MockAnalyticsService!
    private var mockUserDataStore: MockUserDataStore!
    private var testObject: KarhooLogoutInteractor!

    override func setUp() {
        super.setUp()

        mockUserDataStore = MockUserDataStore()
        mockAnalytics = MockAnalyticsService()

        testObject = KarhooLogoutInteractor(userDataStore: mockUserDataStore,
                                           analytics: mockAnalytics)
    }

    /**
     *  Given:  The user is logged in
     *  When:   Trying to log out
     *  Then:   The users credentials should be removed
     *   And:   Logout analytics event should be fired
     *   And:   Logout callback should be called
     */
    func testUserLoggedInLogOut() {
        var result: Result<KarhooVoid>?
        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user

        testObject.execute(callback: { result = $0 })

        XCTAssertTrue(mockUserDataStore.removeUserCalled)
        XCTAssertEqual(mockAnalytics.eventSent, AnalyticsConstants.EventNames.userLoggedOut)
        XCTAssertTrue(result!.isSuccess())
    }

    /**
     *  Given:  User is NOT logged in
     *  When:   Trying to log out
     *  Then:   The logout should fail
     *   And:   Logout anlaytics event should NOT be fired
     */
    func testUserLoggedOutLogOut() {
        var result: Result<KarhooVoid>?
        testObject.execute(callback: { result = $0 })

        XCTAssertFalse(mockUserDataStore.removeUserCalled)
        XCTAssertFalse(result!.isSuccess())
    }

    /**
     *  Given:  No user logged in
     *  When:   Logging out
     *  Then:   An error should be returned
     */
    func testNoUser() {
        var result: Result<KarhooVoid>?
        testObject.execute(callback: { result = $0 })

        XCTAssert(result?.isSuccess() == false)
    }
}
