//
//  VehicleAttributes.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct VehicleAttributes: Codable, Equatable {

    public let childSeat: Bool
    public let electric: Bool
    public let hybrid: Bool
    public let luggageCapacity: Int
    public let passengerCapacity: Int

    public init(childSeat: Bool = false,
                electric: Bool = false,
                hybrid: Bool = false,
                luggageCapacity: Int = 0,
                passengerCapacity: Int = 0) {
        self.childSeat = childSeat
        self.electric = electric
        self.hybrid = hybrid
        self.luggageCapacity = luggageCapacity
        self.passengerCapacity = passengerCapacity
    }

    enum CodingKeys: String, CodingKey {
        case childSeat = "child_seat"
        case electric
        case hybrid
        case luggageCapacity = "luggage_capacity"
        case passengerCapacity = "passenger_capacity"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.childSeat = (try? container.decode(Bool.self, forKey: .childSeat)) ?? false
        self.electric = (try? container.decode(Bool.self, forKey: .electric)) ?? false
        self.hybrid = (try? container.decode(Bool.self, forKey: .hybrid)) ?? false
        self.luggageCapacity = (try? container.decode(Int.self, forKey: .luggageCapacity)) ?? 0
        self.passengerCapacity = (try? container.decode(Int.self, forKey: .passengerCapacity)) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(childSeat, forKey: .childSeat)
        try container.encode(electric, forKey: .electric)
        try container.encode(hybrid, forKey: .hybrid)
        try container.encode(luggageCapacity, forKey: .luggageCapacity)
        try container.encode(passengerCapacity, forKey: .passengerCapacity)
    }
}
