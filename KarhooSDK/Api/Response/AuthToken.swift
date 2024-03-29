//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

typealias AuthTokenKeys = AuthToken.CodingKeys

public struct AuthToken: KarhooCodableModel {

    var accessToken: String
    var expiresIn: Int
    var refreshToken: String
    var refreshExpiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case refreshExpiresIn = "refresh_expires_in"
    }

    public init(accessToken: String = "",
         expiresIn: Int = 0,
         refreshToken: String = "",
         refreshExpiresIn: Int = 0) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
        self.refreshExpiresIn = refreshExpiresIn
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = (try? container.decodeIfPresent(String.self, forKey: .accessToken)) ?? ""
        expiresIn = (try? container.decodeIfPresent(Int.self, forKey: .expiresIn)) ?? 0
        refreshToken = (try? container.decodeIfPresent(String.self, forKey: .refreshToken)) ?? ""
        refreshExpiresIn = (try? container.decodeIfPresent(Int.self, forKey: .refreshExpiresIn)) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(expiresIn, forKey: .expiresIn)
        try container.encode(refreshToken, forKey: .refreshToken)
        try container.encode(refreshExpiresIn, forKey: .refreshExpiresIn)
    }

    func toCredentials(withRefreshToken refreshToken: String? = nil) -> Credentials {
        Credentials(
            accessToken: accessToken,
            expiresIn: TimeInterval(expiresIn),
            refreshToken: refreshToken ?? self.refreshToken,
            refreshTokenExpiresIn: TimeInterval(refreshExpiresIn)
        )
    }
}
