//
//  RefreshToken.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

struct RefreshToken: KarhooCodableModel {

    var accessToken: String
    var expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }

    func toCredentials(withRefreshToken refreshToken: String?) -> Credentials {
        return Credentials(accessToken: accessToken,
                           expiresIn: TimeInterval(expiresIn),
                           refreshToken: refreshToken)
    }
}
