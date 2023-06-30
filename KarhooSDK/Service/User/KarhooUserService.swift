//
//  KarhooUserService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooUserService: UserService {

    private let userDataStore: UserDataStore
    private let logoutInteractor: KarhooExecutable


    init(userDataStore: UserDataStore = DefaultUserDataStore(),
         logoutInteractor: KarhooExecutable = KarhooLogoutInteractor()) {
        self.userDataStore = userDataStore
        self.logoutInteractor = logoutInteractor
    }

    public func logout() -> Call<KarhooVoid> {
        return Call(executable: logoutInteractor)
    }

    public func getCurrentUser() -> UserInfo? {
        return userDataStore.getCurrentUser()
    }

    public func add(observer: UserStateObserver) {
        userDataStore.add(observer: observer)
    }

    public func remove(observer: UserStateObserver) {
        userDataStore.remove(observer: observer)
    }
}
