//
//  QuoteSearch.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

/**
 Used to get a list of Quotes.

 @param origin: The pickup location for a booking.

 @param destination: The drop off location for a booking.

 @param dateScheduled: UTC-0 date and time for prebooks, leave blank for ASAP quotes.

 */
public struct QuoteSearch: KarhooCodableModel {

    public let origin: LocationInfo
    public let destination: LocationInfo

    /**
     The date/time you would like to book for in UTC-0.
     That Will be converted to a ISO-8601 string
     Leave nil for asap quotes.
     */
    public let dateScheduled: Date?

    public init(origin: LocationInfo = LocationInfo(),
                destination: LocationInfo = LocationInfo(),
                dateScheduled: Date? = nil) {
        self.origin = origin
        self.destination = destination
        self.dateScheduled = dateScheduled
    }
}
