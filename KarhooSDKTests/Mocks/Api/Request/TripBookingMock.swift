//
//  BookingRequestPayloadMock.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class TripBookingMock {

    private var tripBooking: TripBooking

    init() {
        self.tripBooking = TripBooking(quoteId: "")
    }

    func set(quoteId: String) -> TripBookingMock {
        self.tripBooking = TripBooking(quoteId: quoteId)
        return self
    }

    func set(passengers: Passengers) -> TripBookingMock {
        self.tripBooking = TripBooking(quoteId: tripBooking.quoteId)
        return self
    }

    func set(flightNumber: String) -> TripBookingMock {
        self.tripBooking = TripBooking(quoteId: tripBooking.quoteId,
                                       flightNumber: flightNumber)
        return self
    }
    
    func set(meta: [String: Any]) -> TripBookingMock {
        self.tripBooking = TripBooking(quoteId: tripBooking.quoteId,
                                       meta: tripBooking.meta)
        return self
    }

    func build() -> TripBooking {
        return tripBooking
    }
}
