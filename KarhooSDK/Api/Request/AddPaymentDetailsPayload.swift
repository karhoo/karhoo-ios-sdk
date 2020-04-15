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
    public let payer: Payer
    public let organisationId: String

    public init(nonce: String = "",
                payer: Payer = Payer(),
                organisationId: String = "") {

        self.nonce = nonce
        self.payer = payer
        self.organisationId = organisationId
    }

    enum CodingKeys: String, CodingKey {
        case nonce
        case payer
        case organisationId = "organisation_id"
    }
}
