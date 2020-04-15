//
//  RefreshTokenRequestPayload.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

struct RefreshTokenRequestPayload: KarhooCodableModel {

    let refreshToken: String

    init(refreshToken: String) {
        self.refreshToken = refreshToken
    }

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}
