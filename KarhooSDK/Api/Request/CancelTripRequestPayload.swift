//
//  CancelTripRequestPayload.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

struct CancelTripRequestPayload: KarhooCodableModel {
    let reason: String

    init(reason: CancelReason) {
        self.reason = reason.rawValue
    }

    enum CodingKeys: String, CodingKey {
        case reason = "reason"
    }
}
