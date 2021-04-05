//
//  LoginDataStore.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol UserDataStore {
    func getCurrentUser() -> UserInfo?
    func getCurrentCredentials() -> Credentials?
    func setCurrentUser(user: UserInfo, credentials: Credentials)
    func updateCurrentUserNonce(nonce: Nonce?)
    func updatePaymentProvider(paymentProvider: PaymentProvider?)
    func updateUser(user: inout UserInfo)
    func removeCurrentUserAndCredentials()
    func set(credentials: Credentials)
    func add(observer: UserStateObserver)
    func remove(observer: UserStateObserver)
}

private let staticBroadcaster = Broadcaster<AnyObject>()

final class DefaultUserDataStore: UserDataStore {

    static let currentUserKey = "currentUser"

    private let secretStore: SecretStore
    private let persistantStore: UserDefaults
    private let broadcaster: Broadcaster<AnyObject>

    init(secretStore: SecretStore = KeychainSecretStore(),
         persistantStore: UserDefaults = .standard,
         broadcaster: Broadcaster<AnyObject> = staticBroadcaster) {
        self.secretStore = secretStore
        self.persistantStore = persistantStore
        self.broadcaster = broadcaster
    }

    func getCurrentUser() -> UserInfo? {
        if let guest = guestUser() {
            return guest
        }

        guard let rawData = rawUserData() else {
            return nil
        }

        return decodeUserFrom(data: rawData)
    }

    private func rawUserData() -> Data? {
        guard let rawData = persistantStore.value(forKey: DefaultUserDataStore.currentUserKey) as? Data else {
            return nil
        }
        return rawData
    }

    private func decodeUserFrom(data: Data) -> UserInfo? {
        let user = try? JSONDecoder().decode(UserInfo.self, from: data)
        return user
    }

    func getCurrentCredentials() -> Credentials? {
        guard let accessToken = secretStore.readSecret(withKey: CredentialsStoreKeys.accessToken.rawValue) else {
            return nil
        }
        let refreshToken = secretStore.readSecret(withKey: CredentialsStoreKeys.refreshToken.rawValue)
        var expiryDate: Date?
        if let expiryDateString = secretStore.readSecret(withKey: CredentialsStoreKeys.expiryDate.rawValue),
           let expiryTimeInterval = TimeInterval(expiryDateString) {
            expiryDate = Date(timeIntervalSince1970: expiryTimeInterval)
        }
        return Credentials(accessToken: accessToken, expiryDate: expiryDate, refreshToken: refreshToken)
    }

    func set(credentials: Credentials) {
        secretStore.saveSecret(credentials.accessToken, withKey: CredentialsStoreKeys.accessToken.rawValue)

        if let expirationTimeInterval = credentials.expiryDate?.timeIntervalSince1970 {
            secretStore.saveSecret(String(expirationTimeInterval), withKey: CredentialsStoreKeys.expiryDate.rawValue)
        } else {
            secretStore.deleteSecret(withKey: CredentialsStoreKeys.expiryDate.rawValue)
        }

        if let refreshToken = credentials.refreshToken {
            secretStore.saveSecret(refreshToken, withKey: CredentialsStoreKeys.refreshToken.rawValue)
        } else {
            secretStore.deleteSecret(withKey: CredentialsStoreKeys.refreshToken.rawValue)
        }
    }

    func setCurrentUser(user: UserInfo, credentials: Credentials) {
        guard let userData = user.encode() else {
            return
        }

        persistantStore.set(userData, forKey: DefaultUserDataStore.currentUserKey)
        set(credentials: credentials)

        broadcastChange()
    }
    
    func updateCurrentUserNonce(nonce: Nonce?) {
        guard var user = getCurrentUser() else {
            return
        }

        user.nonce = nonce
        updateUser(data: user.encode())
    }

    func updatePaymentProvider(paymentProvider: PaymentProvider?) {
        guard var user = getCurrentUser() else {
            return
        }

        user.paymentProvider = paymentProvider
        updateUser(data: user.encode())
    }

    private func updateUser(data: Data?) {
        guard let data = data else {
            return
        }

        persistantStore.set(data, forKey: DefaultUserDataStore.currentUserKey)
        broadcastChange()
    }

    func updateUser( user: inout UserInfo) {
        if let currentNonce = getCurrentUser()?.nonce {
            user.nonce = currentNonce
        }

        if let currentPaymentProvider = getCurrentUser()?.paymentProvider {
            user.paymentProvider = currentPaymentProvider
        }

        updateUser(data: user.encode())
    }

    func removeCurrentUserAndCredentials() {
        persistantStore.removeObject(forKey: DefaultUserDataStore.currentUserKey)

        secretStore.deleteSecret(withKey: CredentialsStoreKeys.accessToken.rawValue)
        secretStore.deleteSecret(withKey: CredentialsStoreKeys.expiryDate.rawValue)
        secretStore.deleteSecret(withKey: CredentialsStoreKeys.refreshToken.rawValue)

        broadcastChange()
    }

    func add(observer: UserStateObserver) {
        broadcaster.add(listener: observer)
    }

    func remove(observer: UserStateObserver) {
        broadcaster.remove(listener: observer)
    }

    private func broadcastChange() {
        broadcaster.broadcast { (observer: AnyObject) in
            guard let observer = observer as? UserStateObserver else {
                return
            }
            observer.userStateUpdated(user: getCurrentUser())
        }
    }

    private func guestUser() -> UserInfo? {
        guard let guestConfig = Karhoo.configuration.authenticationMethod().guestSettings else {
            return nil
        }

        let primaryOrg = Organisation(id: guestConfig.organisationId,
                                      name: "",
                                      roles: [])
        var guestUser = UserInfo(userId: "",
                                 firstName: "",
                                 lastName: "",
                                 email: "",
                                 mobileNumber: "",
                                 organisations: [primaryOrg],
                                 nonce: nil,
                                 paymentProvider: nil,
                                 locale: "",
                                 externalId: "")

        guard let storedUserData = rawUserData() else {
            return guestUser
        }

        if let paymentProvider = decodeUserFrom(data: storedUserData)?.paymentProvider {
            guestUser.paymentProvider = paymentProvider
        }

        return guestUser
    }
}
