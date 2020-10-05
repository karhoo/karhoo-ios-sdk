//
//  AdyenPaymentsDetailsRequestPayload.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 01/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct PaymentsDetailsRequestPayload: Codable, KarhooCodableModel {
    
    public let transactionID: String
    public let paymentsPayload: DecodableData
    
    public init(transactionID: String = "",
                paymentsPayload: DecodableData = DecodableData(data: Data())) {
        self.transactionID = transactionID
        self.paymentsPayload = paymentsPayload
    }
    
    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case paymentsPayload = "payments_payload"
    }
}
