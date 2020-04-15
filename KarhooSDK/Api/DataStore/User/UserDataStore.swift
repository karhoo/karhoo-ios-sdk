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
    func updateUser(user: inout UserInfo)
    func removeCurrentUserAndCredentials()
    func set(credentials: Credentials)
    func add(observer: UserStateObserver)
    func remove(observer: UserStateObserver)
}

private let staticBroadcaster = Broadcaster<AnyObject>()

final class DefaultUserDataStore: UserDataStore {

    static let currentUserKey = "currentUser"
    static let currentCredentialsKey = "currentCredentials"

    private let persistantStore: UserDefaults
    private let credentialsParser: CredentialsParser
    private let broadcaster: Broadcaster<AnyObject>

    init(persistantStore: UserDefaults = UserDefaults.standard,
         credentialsParser: CredentialsParser = DefaultCredentialsParser(),
         broadcaster: Broadcaster<AnyObject> = staticBroadcaster) {
        self.persistantStore = persistantStore
        self.credentialsParser = credentialsParser
        self.broadcaster = broadcaster
    }

    func getCurrentUser() -> UserInfo? {
        guard let rawData = persistantStore.value(forKey: DefaultUserDataStore.currentUserKey) as? Data else {
            return nil
        }

        let user = try? JSONDecoder().decode(UserInfo.self, from: rawData)
        return user?.userId.isEmpty == true ? nil : user
    }

    func getCurrentCredentials() -> Credentials? {
        let rawData = persistantStore.value(forKey: DefaultUserDataStore.currentCredentialsKey) as? [String: Any]
        let credentials = credentialsParser.from(dictionary: rawData)

        return credentials
    }

    func set(credentials: Credentials) {
        let updatedCredentials = credentialsParser.from(credentials: credentials)
        persistantStore.set(updatedCredentials, forKey: DefaultUserDataStore.currentCredentialsKey)
        persistantStore.synchronize()
    }

    func setCurrentUser(user: UserInfo, credentials: Credentials) {
        guard let userData = user.encode() else {
            return
        }
        persistantStore.set(userData, forKey: DefaultUserDataStore.currentUserKey)

        let credentials = credentialsParser.from(credentials: credentials)
        persistantStore.set(credentials, forKey: DefaultUserDataStore.currentCredentialsKey)
        persistantStore.synchronize()

        broadcastChange()
    }
    
    func updateCurrentUserNonce(nonce: Nonce?) {
        guard var user = getCurrentUser() else {
            return
        }

        user.nonce = nonce

        guard let updatedUserData = user.encode() else {
            return
        }

        persistantStore.set(updatedUserData, forKey: DefaultUserDataStore.currentUserKey)
        broadcastChange()
    }

    func updateUser( user: inout UserInfo) {
        if let currentNonce = getCurrentUser()?.nonce {
            user.nonce = currentNonce
        }

        guard let newUserData = user.encode() else {
            return
        }

        persistantStore.set(newUserData, forKey: DefaultUserDataStore.currentUserKey)
        persistantStore.synchronize()
        broadcastChange()
    }

    func removeCurrentUserAndCredentials() {
        persistantStore.removeObject(forKey: DefaultUserDataStore.currentUserKey)
        persistantStore.removeObject(forKey: DefaultUserDataStore.currentCredentialsKey)
        persistantStore.synchronize()

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
}
