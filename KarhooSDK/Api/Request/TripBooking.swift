//
//  TripBooking.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct TripBooking: KarhooCodableModel, Equatable {

    public let quoteId: String
    public let passengers: Passengers
    public let flightNumber: String?
    public var paymentNonce: String?

    public init(quoteId: String = "",
                passengers: Passengers = Passengers(),
                flightNumber: String? = nil,
                paymentNonce: String? = nil) {
        self.quoteId = quoteId
        self.passengers = passengers
        self.flightNumber = flightNumber
        self.paymentNonce = paymentNonce
    }

    enum CodingKeys: String, CodingKey {
        case quoteId = "quote_id"
        case passengers
        case flightNumber = "flight_number"
        case paymentNonce = "payment_nonce"
    }
}
