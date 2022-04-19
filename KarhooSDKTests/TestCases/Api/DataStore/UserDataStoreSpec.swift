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

    private var mockSecretStore: MockSecretStore!
    private var mockUserDefaults: MockUserDefaults!
    private var mockObserver: MockObserver!
    private var mockBroadcaster: MockBroadcaster!

    private var testObject: DefaultUserDataStore!

    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        mockObserver = MockObserver()
        mockBroadcaster = MockBroadcaster()
        mockSecretStore = MockSecretStore()
        testObject = DefaultUserDataStore(secretStore: mockSecretStore,
                                          persistantStore: mockUserDefaults,
                                          broadcaster: mockBroadcaster)
        testObject.add(observer: mockObserver)
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
        let testCredentials = ObjectTestFactory.getRandomCredentials()
        testObject.set(credentials: testCredentials)
        XCTAssertEqual(mockSecretStore.secretsForKeysToSave[CredentialsStoreKeys.accessToken.rawValue],
                       testCredentials.accessToken)
        XCTAssertEqual(mockSecretStore.secretsForKeysToSave[CredentialsStoreKeys.refreshToken.rawValue],
                       testCredentials.refreshToken)
        let expectedExpirationDateString = String(testCredentials.expiryDate!.timeIntervalSince1970)
        XCTAssertEqual(mockSecretStore.secretsForKeysToSave[CredentialsStoreKeys.expiryDate.rawValue],
                       expectedExpirationDateString)
    }

    /**
      * Given: Credentials are missing the expiration date
      * When: Setting credentials
      * Then: The secret store should delete the expiration date from the secret store
      */
    func testWhenSettingCredentialsWithoutExpirationDateShouldDeleteTheExpirationDateFromTheSecretStore() {
        let testCredentials = ObjectTestFactory.getRandomCredentials(expiryDate: nil)
        testObject.set(credentials: testCredentials)
        XCTAssertTrue(mockSecretStore.keysToDeleteValuesFor.contains(CredentialsStoreKeys.expiryDate.rawValue))
    }

    /**
      * Given: Credentials are missing the refresh token
      * When: Setting credentials
      * Then: The secret store should delete the refresh token from the secret store
      */
    func testWhenSettingCredentialsWithoutRefreshTokenShouldDeleteTheRefreshTokenFromTheSecretStore() {
        let testCredentials = ObjectTestFactory.getRandomCredentials(withRefreshToken: false)
        testObject.set(credentials: testCredentials)
        XCTAssertTrue(mockSecretStore.keysToDeleteValuesFor.contains(CredentialsStoreKeys.refreshToken.rawValue))
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
        mockSecretStore.secretsForKeysToRead[CredentialsStoreKeys.accessToken.rawValue] = nil
        XCTAssertNil(testObject.getCurrentCredentials())
    }

    /**
     *  Given:  There is an access token stored
     *  When:   Getting the current credentials
     *  Then:   Should return correct values
     */
    func testWhenOnlyAnAccessTokenIsAvailableShouldBePossibleToBuildTheCredentialsObject() {
        mockSecretStore.secretsForKeysToRead[CredentialsStoreKeys.refreshToken.rawValue] = nil
        mockSecretStore.secretsForKeysToRead[CredentialsStoreKeys.expiryDate.rawValue] = nil
        let credentials = testObject.getCurrentCredentials()
        XCTAssertEqual(credentials?.accessToken,
                       mockSecretStore.secretsForKeysToRead[CredentialsStoreKeys.accessToken.rawValue])
        XCTAssertNil(credentials?.refreshToken)
        XCTAssertNil(credentials?.expiryDate)
    }

    /**
     *  Given:  There is an access token stored and a refresh token
     *  When:   Getting the current credentials
     *  Then:   Should return correct values
     */
    func testWhenAnAccessAndRefreshTokensAreAvailableShouldBePossibleToBuildTheCredentialsObject() {
        mockSecretStore.secretsForKeysToRead[CredentialsStoreKeys.expiryDate.rawValue] = nil
        let credentials = testObject.getCurrentCredentials()
        XCTAssertEqual(credentials?.accessToken,
                       mockSecretStore.secretsForKeysToRead[CredentialsStoreKeys.accessToken.rawValue])
        XCTAssertEqual(credentials?.refreshToken,
                       mockSecretStore.secretsForKeysToRead[CredentialsStoreKeys.refreshToken.rawValue])
        XCTAssertNil(credentials?.expiryDate)
    }

    /**
     *  Given:  There is an access token stored and an expiration date
     *  When:   Getting the current credentials
     *  Then:   Should return correct values
     */
    func testWhenAnAccessTokenAndExpirationDateAreAvailableShouldBePossibleToBuildTheCredentialsObject() {
        mockSecretStore.secretsForKeysToRead[CredentialsStoreKeys.refreshToken.rawValue] = nil
        let credentials = testObject.getCurrentCredentials()
        XCTAssertEqual(credentials?.accessToken,
                       mockSecretStore.secretsForKeysToRead[CredentialsStoreKeys.accessToken.rawValue])
        let expectedExpirationDateString = mockSecretStore.secretsForKeysToRead[CredentialsStoreKeys.expiryDate.rawValue]!!
        let expectedExpirationDateTimeInterval = TimeInterval(expectedExpirationDateString)!
        let expectedExpirationDate = Date(timeIntervalSince1970: expectedExpirationDateTimeInterval)
        XCTAssertEqual(credentials?.expiryDate?.compare(expectedExpirationDate), .orderedSame)
        XCTAssertNil(credentials?.refreshToken)
    }

    /**
     *  Given:  There are all credentials stored
     *  When:   Getting the current credentials
     *  Then:   Should return correct values
     */
    func testWhenAllCredentialInfoIsAvailableShouldBePossibleToBuildTheCredentialsObject() {
        let credentials = testObject.getCurrentCredentials()
        XCTAssertEqual(credentials?.accessToken,
                       mockSecretStore.secretsForKeysToRead[CredentialsStoreKeys.accessToken.rawValue])
        let expectedExpirationDateString = mockSecretStore.secretsForKeysToRead[CredentialsStoreKeys.expiryDate.rawValue]!!
        let expectedExpirationDateTimeInterval = TimeInterval(expectedExpirationDateString)!
        let expectedExpirationDate = Date(timeIntervalSince1970: expectedExpirationDateTimeInterval)
        XCTAssertEqual(credentials?.expiryDate?.compare(expectedExpirationDate), .orderedSame)
        XCTAssertEqual(credentials?.refreshToken,
                       mockSecretStore.secretsForKeysToRead[CredentialsStoreKeys.refreshToken.rawValue])
    }

    /**
     *  Given:  A stored user
     *  When:   Setting a new user
     *  Then:   The stored user should be replaced by the new user
     */
    func testSetUserWhenExistingUser() {
        let newUser = UserInfoMock().set(userId: "some").build()

        let newCredentials = ObjectTestFactory.getRandomCredentials()

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
        testObject.setCurrentUser(user: newUser, credentials: newCredentials)

        XCTAssertEqual(newUser, testObject.getCurrentUser())

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

        XCTAssert(mockObserver.userStateUpdateCalled)
        XCTAssertNil(mockObserver.userUpdatedTo)
    }

    /**
     *  When:   Trying to remove the current user and credentials
     *  Then:   Should remove the access token from the secret store
     */
    func testWhenRemovingCurrentUserCredentialsShouldRemoveTheAccessTokenFromSecretStore() {
        testObject.removeCurrentUserAndCredentials()
        XCTAssertTrue(mockSecretStore.keysToDeleteValuesFor.contains(CredentialsStoreKeys.accessToken.rawValue))
    }

    /**
     *  When:   Trying to remove the current user and credentials
     *  Then:   Should remove the refresh token from the secret store
     */
    func testWhenRemovingCurrentUserCredentialsShouldRemoveTheRefreshTokenFromSecretStore() {
        testObject.removeCurrentUserAndCredentials()
        XCTAssertTrue(mockSecretStore.keysToDeleteValuesFor.contains(CredentialsStoreKeys.refreshToken.rawValue))
    }

    /**
     *  When:   Trying to remove the current user and credentials
     *  Then:   Should remove the access token from the secret store
     */
    func testWhenRemovingCurrentUserCredentialsShouldRemoveTheExpirationDateFromSecretStore() {
        testObject.removeCurrentUserAndCredentials()
        XCTAssertTrue(mockSecretStore.keysToDeleteValuesFor.contains(CredentialsStoreKeys.expiryDate.rawValue))
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

        let newPaymentProvider = PaymentProvider(provider: Provider(id: "braintree"), version: "v68")
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
        let currentUserData = UserInfoMock().set(userId: "nonceUser")
            .set(nonce: Nonce(nonce: "some"))
            .set(paymentProvider: PaymentProvider(provider: Provider(id: "123"), version: "v68"))
            .build()

        var newUserUpdate = UserInfoMock().set(userId: "nonceUser").build()

        mockUserDefaults.set(currentUserData.encode()!, forKey: DefaultUserDataStore.currentUserKey)

        testObject.updateUser(user: &newUserUpdate)
        XCTAssertTrue(mockObserver.userStateUpdateCalled)

        XCTAssertNotNil(testObject.getCurrentUser()?.nonce)
        XCTAssertEqual(testObject.getCurrentUser()?.nonce, currentUserData.nonce)
    }

    /**
     * When: SDK is in guest mode
     * When: Getting the current user
     * Then: blank user should return with the organisation id set
     */
    func testGuestUserReturnsWithOrganisationId() {
        MockSDKConfig.authenticationMethod = .guest(settings: MockSDKConfig.guestSettings)

        XCTAssertEqual(MockSDKConfig.guestSettings.organisationId,
                       testObject.getCurrentUser()?.organisations[0].id)
        XCTAssertEqual("", testObject.getCurrentUser()?.userId)

        MockSDKConfig.authenticationMethod = .karhooUser
    }

    /**
     * Given: SDK is in guest mode
     * When: Updating payment provider
     * Then: payment provider should be set on the user
     * And: observer should be broadcasted
     */
    func testUpdatePaymentProviderGuestUser() {
        MockSDKConfig.authenticationMethod = .guest(settings: MockSDKConfig.guestSettings)

        let user = testObject.getCurrentUser()

        XCTAssertNil(user?.paymentProvider)

        let newPaymentProvider = PaymentProvider(provider: Provider(id: "braintree"), version: "v68")
        testObject.updatePaymentProvider(paymentProvider: newPaymentProvider)

        XCTAssertEqual(testObject.getCurrentUser()?.paymentProvider?.provider.type, .braintree)
        XCTAssertEqual(mockObserver.userUpdatedTo?.paymentProvider?.provider.type, .braintree)
        XCTAssertTrue(mockObserver.userStateUpdateCalled)

        MockSDKConfig.authenticationMethod = .karhooUser
    }
    
    /**
     * When: Updating the status for a loyalty program
     * Then: That status should be retrived from the persistent store
     */
    func testUpdateLoyaltyStatusForLoyaltyId() {
        let loyaltyId = TestUtil.getRandomString()
        let balance = TestUtil.getRandomInt()
        testObject.updateLoyaltyStatus(status: LoyaltyStatus(balance: balance, canBurn: true, canEarn: false), forLoyaltyId: loyaltyId)
        let status = testObject.getLoyaltyStatusFor(loyaltyId: loyaltyId)
        
        XCTAssertNotNil(status)
        XCTAssertEqual(status?.balance, balance)
    }
    
    /**
     * Given: The status was not persisted for a given loyalty id
     * Then: No status should  be retrived from the persistent store
     */
    func testGetLoyaltyStatusForLoyaltyIdForUnexistingLoyaltyId() {
        let loyaltyId = TestUtil.getRandomString()
        let status = testObject.getLoyaltyStatusFor(loyaltyId: loyaltyId)
        
        XCTAssertNil(status)
    }
    
    /**
     * Given: The loyalty id is an empty string
     * Then: No status should  be retrived from the persistent store
     */
    func testGetLoyaltyStatusForLoyaltyIdForEmptyLoyaltyId() {
        let status = testObject.getLoyaltyStatusFor(loyaltyId: "")
        
        XCTAssertNil(status)
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
