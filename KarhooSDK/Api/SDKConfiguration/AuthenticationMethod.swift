//
//  AuthenticationMethod.swift
//  KarhooSDK
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public enum AuthenticationMethod {
    case karhooUser
    case tokenExchange(settings: TokenExchangeSettings)
    case guest(settings: GuestSettings)

    public var tokenExchangeSettings: TokenExchangeSettings? {
        switch self {
        case .tokenExchange(let settings):
            return settings
        default: return nil
        }
    }

    public var guestSettings: GuestSettings? {
        switch self {
        case .guest(let settings):
            return settings
        default: return nil
        }
    }

    public func isGuest() -> Bool {
        return guestSettings != nil
    }
}
