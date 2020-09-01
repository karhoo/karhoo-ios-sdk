//
//  AdyenPaymentsRequest.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 01/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentsRequest: Codable, KarhooCodableModel {
    public let amount: AdyenAmount
    public let reference: String
    public let paymentMethod: AdyenPaymentMethod
    public let returnUrl: String
    public let merchantAccount: String
    
    
    public init(
        amount: AdyenAmount = AdyenAmount(),
        reference: String = "",
        paymentMethod: AdyenPaymentMethod = AdyenPaymentMethod(),
        returnUrl: String = "",
        merchantAccount: String = "") {
        
        self.amount = amount
        self.reference = reference
        self.paymentMethod = paymentMethod
        self.returnUrl = returnUrl
        self.merchantAccount = merchantAccount
    }
    
    enum CodingKeys: String, CodingKey {
        case amount
        case reference
        case paymentMethod
        case returnUrl
        case merchantAccount
    }
}
