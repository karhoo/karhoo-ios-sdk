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
    private let registerInteractor: RegisterInteractor
    private let passwordResetInteractor: PasswordResetInteractor
    private let logoutInteractor: KarhooExecutable
    private let updateUserDetailsInteractor: UpdaterUserDetailsInteractor

    init(userDataStore: UserDataStore = DefaultUserDataStore(),
         registerInteractor: RegisterInteractor = KarhooRegisterInteractor(),
         passwordResetInteractor: PasswordResetInteractor = KarhooPasswordResetInteractor(),
         logoutInteractor: KarhooExecutable = KarhooLogoutInteractor(),
         updateUserDetailsInteractor: UpdaterUserDetailsInteractor = KarhooUpdateUserDetailsInteractor()) {
        self.userDataStore = userDataStore
        self.registerInteractor = registerInteractor
        self.passwordResetInteractor = passwordResetInteractor
        self.logoutInteractor = logoutInteractor
        self.updateUserDetailsInteractor = updateUserDetailsInteractor
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
