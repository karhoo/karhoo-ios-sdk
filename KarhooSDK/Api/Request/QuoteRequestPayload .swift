//
//  QuoteRequestPayload .swift
//  KarhooSDK
//
//  Created by Jeevan Thandi on 14/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct QuoteRequestPayload: Codable, KarhooCodableModel {
    let origin: QuoteRequestPoint
    let destination: QuoteRequestPoint
    let dateScheduled: String?

    init(origin: QuoteRequestPoint,
         destination: QuoteRequestPoint,
         dateScheduled: String? = nil) {
        self.origin = origin
        self.destination = destination
        self.dateScheduled = dateScheduled
    }

    enum CodingKeys: String, CodingKey {
        case origin = "origin"
        case destination = "destination"
        case dateScheduled = "local_time_of_pickup"
    }
}

struct QuoteRequestPoint: KarhooCodableModel {

    let latitude: Double
    let longitude: Double
    let displayAddress: String?

    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case displayAddress = "display_address"
    }
}
