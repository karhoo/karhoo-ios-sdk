//
//  NonceRequestPayload.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct NonceRequestPayload: KarhooCodableModel {

    public let payer: Payer
    public let organisationId: String

    public init(payer: Payer = Payer(),
                organisationId: String = "") {
        self.payer = payer
        self.organisationId = organisationId
    }

    enum CodingKeys: String, CodingKey {
        case payer
        case organisationId = "organisation_id"
    }
}
