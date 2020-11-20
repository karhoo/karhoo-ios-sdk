//
//  QuoteRequestPayload .swift
//  KarhooSDK
//
//  Created by Jeevan Thandi on 14/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

struct QuoteRequest: Codable, KarhooCodableModel {
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
