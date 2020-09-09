//
//  AdyenPaymentMethodsRequest.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethodsRequestPayload: Codable, KarhooCodableModel {
    
    public let channel: String
    public var merchantAccount: String
    public var amount: AdyenAmount

    public init(channel: String = "iOS",
                merchantAccount: String = "",
                amount: AdyenAmount = AdyenAmount()) {
        self.channel = channel
        self.merchantAccount = merchantAccount
        self.amount = amount
    }
    
    enum CodingKeys: String, CodingKey {
        case channel
        case merchantAccount
        case amount
    }
}
