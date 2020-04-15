//
//  TokenExchangeSettings.swift
//  KarhooSDK
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct TokenExchangeSettings {
    let clientId: String
    let scope: String

    public init(clientId: String, scope: String) {
        self.clientId = clientId
        self.scope = scope
    }
}
