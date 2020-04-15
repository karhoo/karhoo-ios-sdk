//
//  GuestSettings.swift
//  KarhooSDK
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct GuestSettings {

    public let identifier: String
    public let referer: String
    public let organisationId: String

    public init(identifier: String,
                referer: String,
                organisationId: String) {
        self.identifier = identifier
        self.referer = referer
        self.organisationId = organisationId
    }
}
