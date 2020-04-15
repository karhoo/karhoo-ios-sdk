//
//  RefreshTokenMock.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class RefreshTokenMock {

    private var refreshToken: RefreshToken

    init() {
        self.refreshToken = RefreshToken(accessToken: "", expiresIn: 0)
    }

    func set(accessToken: String) -> RefreshTokenMock {
        create(accessToken: accessToken)
        return self
    }

    func set(expiresIn: Int) -> RefreshTokenMock {
        create(expiresIn: expiresIn)
        return self
    }

    func build() -> RefreshToken {
        return refreshToken
    }

    func getData() -> Data {
        return refreshToken.encode() ?? Data()
    }

    private func create(accessToken: String? = nil,
                        expiresIn: Int? = nil) {
        self.refreshToken = RefreshToken(accessToken: accessToken ?? refreshToken.accessToken,
                                         expiresIn: expiresIn ?? refreshToken.expiresIn)
    }

}
