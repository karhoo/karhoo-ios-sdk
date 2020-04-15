//
//  RefreshTokenError.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

enum RefreshTokenError: KarhooError {
    case noRefreshToken
    case userAlreadyLoggedOut
}
