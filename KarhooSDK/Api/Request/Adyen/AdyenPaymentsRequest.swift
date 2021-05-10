//
//  AdyenPaymentsRequestPayload.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 25/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentsRequest: KarhooRequestModel {
    
    public let paymentsPayload: AdyenDropInPayload
    public let supplyPartnerID: String

    public init(paymentsPayload: AdyenDropInPayload = AdyenDropInPayload(), supplyPartnerID: String) {
        self.paymentsPayload = paymentsPayload
        self.supplyPartnerID = supplyPartnerID
    }
    
    enum CodingKeys: String, CodingKey {
        case paymentsPayload = "payments_payload"
        case supplyPartnerID = "supply_partner_id"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(paymentsPayload, forKey: .paymentsPayload)
        try container.encode(supplyPartnerID, forKey: .supplyPartnerID)
    }
}
