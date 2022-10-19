//
//  RefreshTokenError.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

enum RefreshTokenError: KarhooError {
    case memoryAllocationError
    case noAccessToken
    case userAlreadyLoggedOut
    case extenalAuthenticationRequestExpired
}
