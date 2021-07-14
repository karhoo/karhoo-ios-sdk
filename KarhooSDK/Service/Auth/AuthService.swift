//
//  SSOAuthService.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public protocol AuthService {
    func login(token: String) -> Call<UserInfo>
    func login(credentials: Credentials?) -> Call<UserInfo>
    func revoke() -> Call<KarhooVoid>
}
