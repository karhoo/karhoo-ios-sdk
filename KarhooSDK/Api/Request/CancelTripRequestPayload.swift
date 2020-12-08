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
    let explanation: String

    init(reason: CancelReason,
         explanation: String) {
        self.reason = reason.rawValue
        self.explanation = explanation
    }

    enum CodingKeys: String, CodingKey {
        case reason = "reason"
        case explanation
    }
}
