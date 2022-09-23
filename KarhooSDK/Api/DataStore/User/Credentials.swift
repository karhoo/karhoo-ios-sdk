//
//  Credentials.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Credentials {
    let accessToken: String
    let expiryDate: Date?
    let refreshToken: String?
    let refreshTokenExpiryDate: Date?

    init(
        accessToken: String,
        expiryDate: Date?,
        refreshToken: String?,
        refreshTokenExpiryDate: Date?
    ) {
        self.accessToken = accessToken
        self.expiryDate = expiryDate
        self.refreshToken = refreshToken
        self.refreshTokenExpiryDate = refreshTokenExpiryDate
    }

    init(
        accessToken: String,
        expiresIn: TimeInterval,
        refreshToken: String?,
        refreshTokenExpiresIn: TimeInterval?
    ) {
        let expiryDate = Date().addingTimeInterval(Double(expiresIn))
        let refreshTokenExpiryDate = refreshTokenExpiresIn.map { Date().addingTimeInterval(Double($0)) }
        self.init(
            accessToken: accessToken,
            expiryDate: expiryDate,
            refreshToken: refreshToken,
            refreshTokenExpiryDate: refreshTokenExpiryDate
        )
    }
}
