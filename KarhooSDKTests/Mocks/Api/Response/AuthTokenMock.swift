//
//  AuthTokenMock.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class AuthTokenMock {

    private var authToken: AuthToken

    init() {
        authToken = AuthToken(accessToken: "", expiresIn: 0, refreshToken: "", refreshExpiresIn: 0)
    }

    func set(accessToken: String) -> AuthTokenMock {
        create(accessToken: accessToken)
        return self
    }

    func set(expiresIn: Int) -> AuthTokenMock {
        create(expiresIn: expiresIn)
        return self
    }

    func set(refreshToken: String) -> AuthTokenMock {
        create(refreshToken: refreshToken)
        return self
    }

    func build() -> AuthToken {
        return authToken
    }

    private func create(accessToken: String? = nil,
                        expiresIn: Int? = nil,
                        refreshToken: String? = nil,
                        refreshExpiresIn: Int = 0) {
        authToken = AuthToken(accessToken: accessToken ?? authToken.accessToken,
                              expiresIn: expiresIn ?? authToken.expiresIn,
                              refreshToken: refreshToken ?? authToken.refreshToken,
                              refreshExpiresIn: refreshExpiresIn)
    }
}
