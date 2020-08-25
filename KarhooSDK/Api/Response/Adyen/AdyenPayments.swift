//
//  AdyenPayments.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 25/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPayments: KarhooCodableModel {
    public let pspReference: String
    public let resultCode: String
    public let amount: AdyenAmount
    public let merchantReference: String
    
    
    public init(pspReference: String = "",
                resultCode: String = "",
                amount: AdyenAmount = AdyenAmount(),
                merchantReference: String = "") {
        self.pspReference = pspReference
        self.resultCode = resultCode
        self.amount = amount
        self.merchantReference = merchantReference
    }
    
    enum CodingKeys: String, CodingKey {
        case pspReference
        case resultCode
        case amount
        case merchantReference
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pspReference = (try? container.decode(String.self, forKey: .pspReference)) ?? ""
        self.resultCode = (try? container.decode(String.self, forKey: .resultCode)) ?? ""
        self.amount = (try? container.decode(AdyenAmount.self, forKey: .amount)) ?? AdyenAmount()
        self.merchantReference = (try? container.decode(String.self, forKey: .merchantReference)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pspReference, forKey: .pspReference)
        try container.encode(resultCode, forKey: .resultCode)
        try container.encode(amount, forKey: .amount)
        try container.encode(merchantReference, forKey: .merchantReference)
    }
    
}
