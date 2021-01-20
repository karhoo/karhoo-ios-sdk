//
//  AdyenPaymentsResponse.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 25/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPayments: KarhooCodableModel {

    public let tripId: String
    public let payload: [String: Any]

    public init(tripId: String = "",
                payload: [String: Any] = [:]) {
        self.tripId = tripId
        self.payload = payload
    }
    
    enum CodingKeys: String, CodingKey {
        case tripId = "trip_id"
        case payload
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tripId = try values.decode(String.self, forKey: .tripId)
        payload = try values.decode([String: Any].self, forKey: .payload)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(payload, forKey: .payload)
        try container.encode(tripId, forKey: .tripId)
    }
}
