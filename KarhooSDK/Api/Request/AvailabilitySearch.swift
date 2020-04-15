//
//  AvailabilitySearch.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

/**
 Used to get availability

 @param originPlaceId: The pickup location place id

 @param destinationPlaceId: The drop off location

 @param dateScheduled: UTC-0 date and time for prebooks, leave blank for ASAP quotes.

 */

public struct AvailabilitySearch: KarhooCodableModel, Equatable {
    let originPlaceId: String
    let destinationPlaceId: String
    let dateScheduled: String?

    init(origin: String = "",
         destination: String = "",
         dateScheduled: String? = nil) {
        self.originPlaceId = origin
        self.destinationPlaceId = destination
        self.dateScheduled = dateScheduled
    }

    enum CodingKeys: String, CodingKey {
        case originPlaceId = "origin_place_id"
        case destinationPlaceId = "destination_place_id"
        case dateScheduled = "date_required"
    }
}
