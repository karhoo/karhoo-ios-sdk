//
//  TripsRequestPayload.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

struct TripsListRequestPayload: KarhooCodableModel {
    let tripStates: [TripState]

    enum CodingKeys: String, CodingKey {
        case tripStates = "trip_states"
    }
}
