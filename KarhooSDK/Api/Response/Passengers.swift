//
//  Passengers.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Passengers: KarhooCodableModel, Equatable {

    public let additionalPassengers: Int
    public let passengerDetails: [PassengerDetails]

    public init(additionalPassengers: Int = 0,
                passengerDetails: [PassengerDetails] = [PassengerDetails()]) {
        self.additionalPassengers = additionalPassengers
        self.passengerDetails = passengerDetails
    }

    enum CodingKeys: String, CodingKey {
        case additionalPassengers = "additional_passengers"
        case passengerDetails = "passenger_details"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.additionalPassengers = (try? container.decode(Int.self, forKey: .additionalPassengers)) ?? 0
        self.passengerDetails = (try? container.decode([PassengerDetails].self, forKey: .passengerDetails)) ?? []
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(additionalPassengers, forKey: .additionalPassengers)
        try container.encode(passengerDetails, forKey: .passengerDetails)
    }
}
