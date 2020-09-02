//
//  AdyenPaymentsDetailsRequest.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 01/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentsDetailsRequest: Codable, KarhooCodableModel {
    
    public let details: AdyenPaymentDetails
    public let paymentData: String
    public let threeDSAuthenticationOnly: Bool
    
    public init(details: AdyenPaymentDetails = AdyenPaymentDetails(),
                paymentData: String = "",
                threeDSAuthenticationOnly: Bool = false) {
        
        self.details = details
        self.paymentData = paymentData
        self.threeDSAuthenticationOnly = threeDSAuthenticationOnly
    }
    
    enum CodingKeys: String, CodingKey {
        case details
        case paymentData
        case threeDSAuthenticationOnly
    }
}
