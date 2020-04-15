//
//  BookingSearch.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

struct BookingSearch: KarhooCodableModel {

    let trips: [TripInfo]

    enum CodingKeys: String, CodingKey {
        case trips = "bookings"
    }
}
