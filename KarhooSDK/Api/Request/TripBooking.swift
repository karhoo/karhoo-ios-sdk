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
    public let trainNumber: String?
    public let trainTime: String?
    public var paymentNonce: String?
    public var comments: String?
    public let partnerTripID: String?
    public let costCenterReference: String?
    public let loyaltyProgrammeID: String?
    public let loyaltyPoints: Int
    public var meta: [String: Any] = [:]

    public init(quoteId: String = "",
                passengers: Passengers = Passengers(),
                flightNumber: String? = nil,
                trainNumber: String? = nil,
                trainTime: String? = nil,
                paymentNonce: String? = nil,
                comments: String? = nil,
                partnerTripID: String? = nil,
                costCenterReference: String? = nil,
                loyaltyProgrammeID: String? = nil,
                loyaltyPoints: Int = 0,
                meta: [String: Any] = [:]) {
        self.quoteId = quoteId
        self.passengers = passengers
        self.flightNumber = flightNumber
        self.trainNumber = trainNumber
        self.trainTime = trainTime
        self.paymentNonce = paymentNonce
        self.comments = comments
        self.partnerTripID = partnerTripID
        self.costCenterReference = costCenterReference
        self.loyaltyProgrammeID = loyaltyProgrammeID
        self.loyaltyPoints = loyaltyPoints
        self.meta = meta
    }

    enum CodingKeys: String, CodingKey {
        case quoteId = "quote_id"
        case passengers
        case comments
        case flightNumber = "flight_number"
        case trainNumber = "train_number"
        case trainTime = "train_time"
        case paymentNonce = "payment_nonce"
        case partnerTripID = "partner_trip_id"
        case costCenterReference = "cost_center_reference"
        case loyaltyProgrammeID = "loyalty_programme"
        case loyaltyPoints = "loyalty_points"
        case meta
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        quoteId = try values.decode(String.self, forKey: .quoteId)
        passengers = try values.decode(Passengers.self, forKey: .passengers)
        flightNumber = try values.decode(String.self, forKey: .flightNumber)
        trainNumber = try values.decode(String.self, forKey: .trainNumber)
        trainTime = try values.decode(String.self, forKey: .trainTime)
        paymentNonce = try values.decode(String.self, forKey: .paymentNonce)
        comments = try values.decode(String.self, forKey: .comments)
        partnerTripID = try values.decode(String.self, forKey: .partnerTripID)
        costCenterReference = try values.decode(String.self, forKey: .costCenterReference)
        loyaltyProgrammeID = try values.decode(String.self, forKey: .loyaltyProgrammeID)
        loyaltyPoints = try values.decode(Int.self, forKey: .loyaltyPoints)
        meta = try values.decode([String: Any].self, forKey: .meta)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(quoteId, forKey: .quoteId)
        try container.encode(passengers, forKey: .passengers)
        try container.encode(flightNumber, forKey: .flightNumber)
        try container.encode(trainNumber, forKey: .trainNumber)
        try container.encode(trainTime, forKey: .trainTime)
        try container.encode(paymentNonce, forKey: .paymentNonce)
        try container.encode(comments, forKey: .comments)
        try container.encode(partnerTripID, forKey: .partnerTripID)
        try container.encode(costCenterReference, forKey: .costCenterReference)
        try container.encode(loyaltyProgrammeID, forKey: .loyaltyProgrammeID)
        try container.encode(loyaltyPoints, forKey: .loyaltyPoints)
        try container.encode(meta, forKey: .meta)
    }
    
    public static func == (lhs: TripBooking, rhs: TripBooking) -> Bool {
        return lhs.quoteId == rhs.quoteId
    }
}
