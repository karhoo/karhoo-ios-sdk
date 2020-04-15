//
//  LoginRequestPayloadMock.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class LoginRequestPayloadMock {

    private var loginRequest: UserLogin

    init() {
        self.loginRequest = UserLogin(username: "", password: "")
    }

    func set(username: String) -> LoginRequestPayloadMock {
        self.loginRequest = UserLogin(username: username,
                                      password: loginRequest.password)

        return self
    }

    func set(password: String) -> LoginRequestPayloadMock {
        self.loginRequest = UserLogin(username: loginRequest.username,
                                      password: password)

        return self
    }

    func build() -> UserLogin {
        return self.loginRequest
    }
}
