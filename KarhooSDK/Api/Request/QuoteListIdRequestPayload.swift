//
//  QuoteListIdRequestPayload.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct QuoteListIdRequestPayload: Codable, KarhooCodableModel {
    let origin: String
    let destination: String
    let dateScheduled: String?

    init(origin: String = "",
         destination: String = "",
         dateScheduled: String? = nil) {
        self.origin = origin
        self.destination = destination
        self.dateScheduled = dateScheduled
    }

    enum CodingKeys: String, CodingKey {
        case origin = "origin_place_id"
        case destination = "destination_place_id"
        case dateScheduled = "local_time_of_pickup"
    }
}
