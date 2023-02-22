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
    public let luggage: Luggage

    public init(additionalPassengers: Int = 0,
                passengerDetails: [PassengerDetails] = [PassengerDetails()],
                luggage: Luggage = Luggage()) {
        self.additionalPassengers = additionalPassengers
        self.passengerDetails = passengerDetails
        self.luggage = luggage
    }

    enum CodingKeys: String, CodingKey {
        case additionalPassengers = "additional_passengers"
        case passengerDetails = "passenger_details"
        case luggage
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.additionalPassengers = (try? container.decodeIfPresent(Int.self, forKey: .additionalPassengers)) ?? 0
        self.passengerDetails = (try? container.decodeIfPresent([PassengerDetails].self, forKey: .passengerDetails)) ?? []
        self.luggage = (try? container.decodeIfPresent(Luggage.self, forKey: .luggage)) ?? Luggage()
        
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(additionalPassengers, forKey: .additionalPassengers)
        try container.encode(passengerDetails, forKey: .passengerDetails)
        try container.encode(luggage, forKey: .luggage)
    }
    
    public static func == (lhs: Passengers, rhs: Passengers) -> Bool {
        return lhs.additionalPassengers == rhs.additionalPassengers
    }
}
