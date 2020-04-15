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
    private let loginInteractor: LoginInteractor
    private let registerInteractor: RegisterInteractor
    private let passwordResetInteractor: PasswordResetInteractor
    private let logoutInteractor: KarhooExecutable
    private let updateUserDetailsInteractor: UpdaterUserDetailsInteractor

    init(userDataStore: UserDataStore = DefaultUserDataStore(),
         loginInteractor: LoginInteractor = KarhooLoginInteractor(),
         registerInteractor: RegisterInteractor = KarhooRegisterInteractor(),
         passwordResetInteractor: PasswordResetInteractor = KarhooPasswordResetInteractor(),
         logoutInteractor: KarhooExecutable = KarhooLogoutInteractor(),
         updateUserDetailsInteractor: UpdaterUserDetailsInteractor = KarhooUpdateUserDetailsInteractor()) {
        self.userDataStore = userDataStore
        self.loginInteractor = loginInteractor
        self.registerInteractor = registerInteractor
        self.passwordResetInteractor = passwordResetInteractor
        self.logoutInteractor = logoutInteractor
        self.updateUserDetailsInteractor = updateUserDetailsInteractor
    }

    public func login(userLogin: UserLogin) -> Call<UserInfo> {
        authenticationMethodSanityCheck()
        loginInteractor.set(userLogin: userLogin)
        return Call(executable: loginInteractor)
    }

    public func logout() -> Call<KarhooVoid> {
        authenticationMethodSanityCheck()
        return Call(executable: logoutInteractor)
    }

    public func getCurrentUser() -> UserInfo? {
        return userDataStore.getCurrentUser()
    }

    func register(userRegistration: UserRegistration) -> Call<UserInfo> {
        authenticationMethodSanityCheck()
        registerInteractor.set(userRegistration: userRegistration)
        return Call(executable: registerInteractor)
    }

    public func passwordReset(email: String) -> Call<KarhooVoid> {
        authenticationMethodSanityCheck()
        passwordResetInteractor.set(email: email)
        return Call(executable: passwordResetInteractor)
    }
    
    public func updateUserDetails(update: UserDetailsUpdateRequest) -> Call<UserInfo> {
        authenticationMethodSanityCheck()
        updateUserDetailsInteractor.set(update: update)
        return Call(executable: updateUserDetailsInteractor)
    }

    public func add(observer: UserStateObserver) {
        userDataStore.add(observer: observer)
    }

    public func remove(observer: UserStateObserver) {
        userDataStore.remove(observer: observer)
    }

    private func authenticationMethodSanityCheck() {
        let error = "The AuthenticationMethod set in KarhooSDKConfiguration does not support this operation"

        switch Karhoo.configuration.authenticationMethod() {
        case .tokenExchange(_:), .guest(_:):
            fatalError(error)
        default:
            return
        }
    }
}
