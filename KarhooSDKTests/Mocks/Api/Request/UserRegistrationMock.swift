//
//  UserRegistrationMock.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class UserRegistrationMock {

    private var userRegistration: UserRegistration

    init() {
        userRegistration = UserRegistration(firstName: "",
                                            lastName: "",
                                            email: "",
                                            phoneNumber: "",
                                            locale: "",
                                            password: "")
    }

    func set(firstName: String) -> UserRegistrationMock {
        create(firstName: firstName)
        return self
    }

    func set(lastName: String) -> UserRegistrationMock {
        create(lastName: lastName)
        return self
    }

    func set(email: String) -> UserRegistrationMock {
        create(email: email)
        return self
    }

    func set(phoneNumber: String) -> UserRegistrationMock {
        create(phoneNumber: phoneNumber)
        return self
    }

    func set(locale: String) -> UserRegistrationMock {
        create(locale: locale)
        return self
    }

    func set(password: String) -> UserRegistrationMock {
        create(password: password)
        return self
    }

    private func create(firstName: String? = nil,
                        lastName: String? = nil,
                        email: String? = nil,
                        phoneNumber: String? = nil,
                        locale: String? = nil,
                        password: String? = nil) {

        userRegistration = UserRegistration(firstName: firstName ?? userRegistration.firstName,
                                            lastName: lastName ?? userRegistration.lastName,
                                            email: email ?? userRegistration.email,
                                            phoneNumber: phoneNumber ?? userRegistration.phoneNumber,
                                            locale: locale ?? userRegistration.locale,
                                            password: password ?? userRegistration.password)
    }

    func build() -> UserRegistration {
        return userRegistration
    }
}
