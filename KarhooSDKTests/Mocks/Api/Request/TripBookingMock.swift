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
        self.tripBooking = TripBooking(quoteId: "",
                                       passengers: Passengers())
    }

    func set(quoteId: String) -> TripBookingMock {
        self.tripBooking = TripBooking(quoteId: quoteId,
                                                passengers: tripBooking.passengers)
        return self
    }

    func set(passengers: Passengers) -> TripBookingMock {
        self.tripBooking = TripBooking(quoteId: tripBooking.quoteId,
                                       passengers: passengers)
        return self
    }

    func set(flightNumber: String) -> TripBookingMock {
        self.tripBooking = TripBooking(quoteId: tripBooking.quoteId,
                                       passengers: tripBooking.passengers,
                                       flightNumber: flightNumber)
        return self
    }
    
    func set(meta: [String: Any]) -> TripBookingMock {
        self.tripBooking = TripBooking(quoteId: tripBooking.quoteId,
                                       passengers: tripBooking.passengers,
                                       meta: tripBooking.meta)
        return self
    }

    func build() -> TripBooking {
        return tripBooking
    }
}
