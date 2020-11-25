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
    public var comments: String?
    public var meta: [String: Any] = [:]

    public init(quoteId: String = "",
                passengers: Passengers = Passengers(),
                flightNumber: String? = nil,
                paymentNonce: String? = nil,
                comments: String? = nil,
                meta: [String: Any] = [:]) {
        self.quoteId = quoteId
        self.passengers = passengers
        self.flightNumber = flightNumber
        self.paymentNonce = paymentNonce
        self.comments = comments
        self.meta = meta
    }

    enum CodingKeys: String, CodingKey {
        case quoteId = "quote_id"
        case passengers
        case comments
        case flightNumber = "flight_number"
        case paymentNonce = "payment_nonce"
        case meta
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        quoteId = try values.decode(String.self, forKey: .quoteId)
        passengers = try values.decode(Passengers.self, forKey: .passengers)
        flightNumber = try values.decode(String.self, forKey: .flightNumber)
        paymentNonce = try values.decode(String.self, forKey: .paymentNonce)
        comments = try values.decode(String.self, forKey: .comments)
        meta = try values.decode([String: Any].self, forKey: .meta)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(quoteId, forKey: .quoteId)
        try container.encode(passengers, forKey: .passengers)
        try container.encode(flightNumber, forKey: .flightNumber)
        try container.encode(paymentNonce, forKey: .paymentNonce)
        try container.encode(comments, forKey: .comments)
        try container.encode(meta, forKey: .meta)
    }
    
    public static func == (lhs: TripBooking, rhs: TripBooking) -> Bool {
        return lhs.quoteId == rhs.quoteId
    }
}
