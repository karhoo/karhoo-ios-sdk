//
//  AdyenPaymentMethodsRequest.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethodsRequest: Codable, KarhooCodableModel {
    
    // The platform where a payment transaction takes place. This field can be used for filtering out payment methods that are only available on specific platforms. Possible values: * iOS * Android * Web
    public let channel: String
    public var amount: AdyenAmount?
    // The combination of a language code and a country code to specify the language to be used in the payment.
    public var shopperLocale: String?

    public init(channel: String = "iOS",
                amount: AdyenAmount? = nil,
                shopperLocale: String? = nil) {
        self.channel = channel
        self.amount = amount
        self.shopperLocale = shopperLocale
    }
    
    enum CodingKeys: String, CodingKey {
        case channel
        case amount
        case shopperLocale
    }
}
