//
//  AuthHeaderKeys.swift
//  KarhooSDK
//
//  Created by Tiziano Bruni on 03/03/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

enum AuthHeaderKeys: String {
    case scope
    case clientId = "client_id"
    case token
    case tokenTypeHint = "token_type_hint"
    case refreshToken = "refresh_token"
    case grantType = "grant_type"
    
    var keyValue: String {
        switch self {
        case .refreshToken:
            return "refresh_token"
        default:
            return ""
        }
    }
}
