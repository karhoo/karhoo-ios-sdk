//
//  AdyenPaymentsDetailsRequestPayload.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 01/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct PaymentsDetailsRequestPayload: KarhooRequestModel {
    
    public let tripId: String
    public let paymentsPayload: [String: Any]
    
    public init(tripId: String = "",
                paymentsPayload: [String: Any]) {
        self.tripId = tripId
        self.paymentsPayload = paymentsPayload
    }
    
    enum CodingKeys: String, CodingKey {
        case tripId = "trip_id"
        case paymentsPayload = "payments_payload"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tripId, forKey: .tripId)
        try container.encode(paymentsPayload, forKey: .paymentsPayload)
    }
}
