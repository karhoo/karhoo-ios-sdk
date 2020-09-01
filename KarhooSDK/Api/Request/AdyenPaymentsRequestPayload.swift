//
//  AdyenPaymentsRequestPayload.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 25/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentsRequestPayload: Codable, KarhooCodableModel {
    public let paymentsPayload: AdyenPaymentsRequest
    public let returnUrlSuffix: String

    
    public init(
        paymentsPayload: AdyenPaymentsRequest = AdyenPaymentsRequest(),
        returnUrlSuffix: String = "") {
        
        self.paymentsPayload = paymentsPayload
        self.returnUrlSuffix = returnUrlSuffix
    }
    
    enum CodingKeys: String, CodingKey {
        case paymentsPayload = "payments_payload"
        case returnUrlSuffix = "return_url_suffix"
    }
}
