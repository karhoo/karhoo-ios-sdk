//
//  AdyenPaymentMethodsRequest.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethodsRequestPayload: Codable, KarhooCodableModel {
    public let channel: String
    public let merchantAccount: String
    
    public init(channel: String = "iOS",
                merchantAccount: String = "") {
        self.channel = channel
        self.merchantAccount = channel
    }
    
    enum CodingKeys: String, CodingKey {
        case channel
        case merchantAccount
    }
}
