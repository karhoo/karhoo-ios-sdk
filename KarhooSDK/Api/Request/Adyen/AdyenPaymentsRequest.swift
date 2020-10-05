//
//  AdyenPaymentsRequestPayload.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 25/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenDropInPayload: KarhooCodableModel {

    public init() {}
    
    public var paymentMethod: [String: Any] = [:]
    public var channel = "iOS"
    public var returnUrl: String = ""
    public var amount: AdyenAmount = AdyenAmount()
    public var storePaymentMethod: Bool = false

    enum CodingKeys: String, CodingKey {
        case paymentMethod
        case channel
        case returnUrl
        case storePaymentMethod
        case amount
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        paymentMethod = try values.decode([String: Any].self, forKey: .paymentMethod)
        channel = try values.decode(String.self, forKey: .channel)
        returnUrl = try values.decode(String.self, forKey: .returnUrl)
        storePaymentMethod = try values.decode(Bool.self, forKey: .storePaymentMethod)
        amount = try values.decode(AdyenAmount.self, forKey: .amount)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(paymentMethod, forKey: .paymentMethod)
        try container.encode(channel, forKey: .channel)
        try container.encode(returnUrl, forKey: .returnUrl)
        try container.encode(storePaymentMethod, forKey: .storePaymentMethod)
        try container.encode(amount, forKey: .amount)
    }
}

public struct AdyenPaymentsRequest: KarhooRequestModel {
    
    public let paymentsPayload: AdyenDropInPayload
    public let returnUrlSuffix: String

    public init(paymentsPayload: AdyenDropInPayload,
                returnUrlSuffix: String = "") {
        self.paymentsPayload = paymentsPayload
        self.returnUrlSuffix = returnUrlSuffix
    }
    
    enum CodingKeys: String, CodingKey {
        case paymentsPayload = "payments_payload"
        case returnUrlSuffix = "return_url_suffix"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(returnUrlSuffix, forKey: .returnUrlSuffix)
        try container.encode(paymentsPayload, forKey: .paymentsPayload)
    }
}
