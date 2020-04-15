//
//  LocationInfoSearch.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct LocationInfoSearch: KarhooCodableModel {

    public let placeId: String
    public let sessionToken: String

    public init(placeId: String,
                sessionToken: String) {
        self.placeId = placeId
        self.sessionToken = sessionToken
    }

    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case sessionToken = "session_token"
    }
}
