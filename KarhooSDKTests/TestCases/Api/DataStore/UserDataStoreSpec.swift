//
//  UserDataStoreSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

class UserDataStoreSpec: XCTestCase {

    private var mockCredentialsParser: MockCredentialsParser!
    private var mockUserDefaults: MockUserDefaults!
    private var mockObserver: MockObserver!
    private var mockBroadcaster: MockBroadcaster!

    private var testObject: DefaultUserDataStore!

    override func setUp() {
        super.setUp()
        mockCredentialsParser = MockCredentialsParser()
        mockUserDefaults = MockUserDefaults()
        mockObserver = MockObserver()
        mockBroadcaster = MockBroadcaster()

        testObject = DefaultUserDataStore(persistantStore: mockUserDefaults,
                                          credentialsParser: mockCredentialsParser,
                                          broadcaster: mockBroadcaster)
        testObject.add(observer: mockObserver)
    }

    override func tearDown() {
        super.tearDown()
        mockUserDefaults.removeObject(forKey: DefaultUserDataStore.currentUserKey)
        _ = mockUserDefaults.synchronize()
    }

    /**
     *  When:   Adding an observer
     *  Then:   The observer should be added to the associated broadcaster
     */
    func testAddObserver() {
        XCTAssert(mockBroadcaster.lastListenerAdded === mockObserver)
    }

    /**
     *  When:   Removing an observer
     *  Then:   The observer should be removed to the associated broadcaster
     */
    func testRemoveObserver() {
        testObject.remove(observer: mockObserver)

        XCTAssert(mockBroadcaster.lastListenerRemoved === mockObserver)
    }

    /**
      * When: Setting credentials
      * Then: Persistant store should be set
      */
    func testSetCredentials() {
        testObject.set(credentials: ObjectTestFactory.getRandomCredentials())
        XCTAssertTrue(mockUserDefaults.setForKeyCalled)
    }

    /**
     *  Given:  A stored user
     *  When:   Getting the current user
     *  Then:   The logged in user should be returned
     */
    func testGetExistingUser() {
        let storedUser = UserInfoMock().set(userId: "some").build()
        mockUserDefaults.set(storedUser.encode()!, forKey: DefaultUserDataStore.currentUserKey)

        let user = testObject.getCurrentUser()

        XCTAssertEqual(user, storedUser)
    }

    /**
     *  Given:  No stored user
     *  When:   Getting the current user
     *  Then:   Nil should be returned
     */
    func testGetNoUser() {
        let user = testObject.getCurrentUser()

        XCTAssertNil(user)
    }

    /**
     *  Given:  No stored credentials
     *  When:   Getting the current credentials
     *  Then:   Nil should be returned
     */
    func testGetNoCredentials() {
        let credentials = testObject.getCurrentCredentials()

        XCTAssertNil(credentials)
    }

    /**
     *  Given:  A stored user
     *  When:   Setting a new user
     *  Then:   The stored user should be replaced by the new user
     */
    func testSetUserWhenExistingUser() {
        let newUser = UserInfoMock().set(userId: "some").build()

        let newCredentials = ObjectTestFactory.getRandomCredentials()
        mockCredentialsParser.dataToReturn = ["credentials": "abc"]

        mockCredentialsParser.credentialsToReturn = newCredentials
        testObject.setCurrentUser(user: newUser, credentials: newCredentials)

        XCTAssertEqual(newUser, testObject.getCurrentUser())

        XCTAssert(mockObserver.userStateUpdateCalled)
        XCTAssertEqual(newUser, mockObserver.userUpdatedTo)
    }

    /**
     *  Given:  No logged in user
     *  When:   Setting a new user
     *  Then:   The new user should be set
     */
    func testSetUser() {
        let newUser = UserInfoMock().set(userId: "some").build()

        let newCredentials = ObjectTestFactory.getRandomCredentials()
        mockCredentialsParser.dataToReturn = ["some": "data"]

        testObject.setCurrentUser(user: newUser, credentials: newCredentials)

        XCTAssertEqual(newUser, testObject.getCurrentUser())

        XCTAssert(mockUserDefaults.synchronizeCalled)

        XCTAssert(mockObserver.userStateUpdateCalled)
        XCTAssertEqual(newUser, testObject.getCurrentUser())
    }

    /**
     *  Given:  A current user exists
     *  When:   Trying to remove the current user
     *  Then:   The current user should be removed
     */
    func testRemoveCurrentUser() {
        mockUserDefaults.set(["test": "test"], forKey: DefaultUserDataStore.currentUserKey)
        testObject.removeCurrentUserAndCredentials()

        XCTAssertNil(mockUserDefaults.value(forKey: DefaultUserDataStore.currentUserKey))
        XCTAssert(mockUserDefaults.synchronizeCalled)

        XCTAssert(mockObserver.userStateUpdateCalled)
        XCTAssertNil(mockObserver.userUpdatedTo)
    }

    /**
     *  Given:  No current user exists
     *  When:   Trying to remove the current user
     *  Then:   Nothing should happen
     */
    func testRemoveCurrentUserNoUser() {
        testObject.removeCurrentUserAndCredentials()

        XCTAssertNil(mockUserDefaults.value(forKey: DefaultUserDataStore.currentUserKey))
        XCTAssert(mockUserDefaults.synchronizeCalled)

        XCTAssert(mockObserver.userStateUpdateCalled)
        XCTAssertNil(mockObserver.userUpdatedTo)
    }

    /**
      * When: Updating user nonce
      * Then: Nonce should be set on the user
      * And: observer should be broadcasted
      */
    func testUpdateNonce() {
        let storedUser = UserInfoMock().set(userId: "some").build()
        mockUserDefaults.set(storedUser.encode()!, forKey: DefaultUserDataStore.currentUserKey)

        let user = testObject.getCurrentUser()

        XCTAssertNil(user?.nonce)

        let newNonce = Nonce(nonce: "some", cardType: "Visa", lastFour: "1234")
        testObject.updateCurrentUserNonce(nonce: newNonce)

        XCTAssertEqual(testObject.getCurrentUser()?.nonce?.nonce, "some")
        XCTAssertEqual(mockObserver.userUpdatedTo?.nonce?.nonce, "some")
        XCTAssertTrue(mockObserver.userStateUpdateCalled)
    }

    /**
     * When: Updating payment provider
     * Then: payment provider should be set on the user
     * And: observer should be broadcasted
     */
    func testUpdatePaymentProvider() {
        let storedUser = UserInfoMock().set(userId: "some").build()
        mockUserDefaults.set(storedUser.encode()!, forKey: DefaultUserDataStore.currentUserKey)

        let user = testObject.getCurrentUser()

        XCTAssertNil(user?.paymentProvider)

        let newPaymentProvider = PaymentProvider(provider: Provider(id: "braintree"))
        testObject.updatePaymentProvider(paymentProvider: newPaymentProvider)

        XCTAssertEqual(testObject.getCurrentUser()?.paymentProvider?.provider.type, .braintree)
        XCTAssertEqual(mockObserver.userUpdatedTo?.paymentProvider?.provider.type, .braintree)
        XCTAssertTrue(mockObserver.userStateUpdateCalled)
    }

    /**
     * When: Updating user nonce to nil
     * Then: Nonce should be set to nil
     * And: observer should be broadcasted
     */
    func testUpdateNilNonce() {
        let storedUser = UserInfoMock().set(userId: "some").build()
        mockUserDefaults.set(storedUser.encode()!, forKey: DefaultUserDataStore.currentUserKey)

        let user = testObject.getCurrentUser()

        XCTAssertNil(user?.nonce)

        testObject.updateCurrentUserNonce(nonce: nil)

        XCTAssertNil(testObject.getCurrentUser()?.nonce?.nonce)
        XCTAssertNil(mockObserver.userUpdatedTo?.nonce?.nonce)
        XCTAssertTrue(mockObserver.userStateUpdateCalled)
    }

    /**
     * When: Updating the current user
     * Then: New user should be persisted
     * And: observer should be broadcasted with new user
     */
    func testUpdateUserData() {
        let existingUser = UserInfoMock().set(userId: "someExistingUser").build()
        var newUser = UserInfoMock().set(userId: "someNewUser").build()

        mockUserDefaults.set(existingUser.encode()!, forKey: DefaultUserDataStore.currentUserKey)

        let currentUser = testObject.getCurrentUser()
        XCTAssertEqual(currentUser?.userId, existingUser.userId)

        testObject.updateUser(user: &newUser)

        XCTAssertTrue(mockObserver.userStateUpdateCalled)
        XCTAssertEqual(testObject.getCurrentUser()?.userId, newUser.userId)
    }

    /**
     * When: Updating the current user
     * Then: New user should be persisted with current user nonce
     * And: observer should be broadcasted with new user
     */
    func testUpdateUserRetainsUserNonce() {
        let currentUserData = UserInfoMock().set(userId: "nonceUser").set(nonce: Nonce(nonce: "some")).set(paymentProvider: PaymentProvider(provider: Provider(id: "123"))).build()

        var newUserUpdate = UserInfoMock().set(userId: "nonceUser").build()

        mockUserDefaults.set(currentUserData.encode()!, forKey: DefaultUserDataStore.currentUserKey)

        testObject.updateUser(user: &newUserUpdate)
        XCTAssertTrue(mockObserver.userStateUpdateCalled)

        XCTAssertNotNil(testObject.getCurrentUser()?.nonce)
        XCTAssertEqual(testObject.getCurrentUser()?.nonce, currentUserData.nonce)
    }
}

private class MockCredentialsParser: CredentialsParser {
    var credentialsToReturn: Credentials?
    var dataToDecode: [String: Any]?

    var credentialsToCode: Credentials?
    var dataToReturn: [String: Any]?

    func from(dictionary: [String: Any]?) -> Credentials? {
        dataToDecode = dictionary
        return credentialsToReturn
    }

    func from(credentials: Credentials?) -> [String: Any]? {
        credentialsToCode = credentials
        return dataToReturn
    }
}

private class MockObserver: UserStateObserver {

    var userStateUpdateCalled = false
    var userUpdatedTo: UserInfo?
    func userStateUpdated(user: UserInfo?) {
        userStateUpdateCalled = true
        userUpdatedTo = user
    }

    func reset() {
        userStateUpdateCalled = false
        userUpdatedTo = nil
    }
}
