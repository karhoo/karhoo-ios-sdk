//
//  AdyenPaymentMethodsRequest.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethodsRequest: Codable, KarhooCodableModel {
    
    public let channel: String
    public var amount: AdyenAmount?

    public init(channel: String = "iOS",
                amount: AdyenAmount? = nil) {
        self.channel = channel
        self.amount = amount
    }
    
    enum CodingKeys: String, CodingKey {
        case channel
        case amount
    }
}
