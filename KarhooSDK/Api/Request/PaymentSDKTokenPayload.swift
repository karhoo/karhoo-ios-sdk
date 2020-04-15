//
//  PaymentSDKTokenPayload.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct PaymentSDKTokenPayload: KarhooCodableModel {

    let organisationId: String
    let currency: String

    public init(organisationId: String = "",
                currency: String = "") {
        self.organisationId = organisationId
        self.currency = currency
    }

    enum CodingKeys: String, CodingKey {
        case organisationId = "organisation_id"
        case currency
    }
}
