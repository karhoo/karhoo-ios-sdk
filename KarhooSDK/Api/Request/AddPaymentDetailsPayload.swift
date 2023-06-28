//
//  AddPaymentDetailsPayload.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct AddPaymentDetailsPayload: KarhooCodableModel {

    public let nonce: String
    public let organisationId: String

    public init(nonce: String = "",
                organisationId: String = "") {

        self.nonce = nonce
        self.organisationId = organisationId
    }

    enum CodingKeys: String, CodingKey {
        case nonce
        case organisationId = "organisation_id"
    }
}
