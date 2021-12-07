//
//  MockUserDataStore.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

class MockUserDataStore: UserDataStore {
    
    var userToReturn: UserInfo?
    var storedUser: UserInfo?

    var credentialsToReturn: Credentials?
    var storedCredentials: Credentials?
    
    var loyaltyStatus: LoyaltyStatus?

    func getCurrentUser() -> UserInfo? {
        return userToReturn
    }

    func getCurrentCredentials() -> Credentials? {
        return credentialsToReturn
    }

    private(set) var setCurrentUserCalled = false
    func setCurrentUser(user: UserInfo, credentials: Credentials) {
        setCurrentUserCalled = true
        storedUser = user
        storedCredentials = credentials
    }

    var removeUserCalled = false
    func removeCurrentUserAndCredentials() {
        userToReturn = nil
        removeUserCalled = true
    }

    var addedObserver: UserStateObserver?
    func add(observer: UserStateObserver) {
        addedObserver = observer
    }

    var removedObserver: UserStateObserver?
    func remove(observer: UserStateObserver) {
        removedObserver = observer
    }

    var credentialsToSet: Credentials?
    func set(credentials: Credentials) {
        credentialsToSet = credentials
    }
    private(set) var updateCurrentNonce: Nonce?
    private(set) var updateCurrentNonceCalled = false
    func updateCurrentUserNonce(nonce: Nonce?) {
        updateCurrentNonce = nonce
        updateCurrentNonceCalled = true
    }

    private(set) var updateUser: UserInfo?
    private(set) var updateUserCalled = false
    func updateUser(user: inout UserInfo) {
        self.updateUser = user
        updateUserCalled = true
    }

    private(set) var updatedPaymentProvider: PaymentProvider?
    func updatePaymentProvider(paymentProvider: PaymentProvider?) {
        self.updatedPaymentProvider = paymentProvider
    }
    
    func updateLoyaltyStatus(status: LoyaltyStatus, forLoyaltyId: String) {
        self.loyaltyStatus = status
    }
    
    func getLoyaltyStatusFor(paymentProvider: PaymentProvider) -> LoyaltyStatus? {
        return loyaltyStatus
    }
    
    func getLoyaltyStatusFor(loyaltyId: String) -> LoyaltyStatus? {
        return loyaltyStatus
    }
}
