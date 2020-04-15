//
// Created by Jeevan on 24/04/2018.
// Copyright (c) 2018 Flit Technologies Ltd. All rights reserved.
//

import Foundation

struct LocationInfoRequestPayload: KarhooCodableModel {
    let placeId: String
    let sessionToken: String

    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case sessionToken = "session_token"
    }
}
