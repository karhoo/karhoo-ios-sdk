//
//  QuoteVehicle.swift
//  KarhooSDK
//
//  Created by Jeevan Thandi on 16/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct QuoteVehicle: Codable {

    public let vehicleClass: String
    public let type: String
    public let tags: [String]
    public let qta: QuoteQta
    public let passengerCapacity: Int
    public let luggageCapacity: Int
    

    public init(vehicleClass: String = "",
                type: String = "",
                tags: [String] = [],
                qta: QuoteQta = QuoteQta(),
                passengerCapacity: Int = 0,
                luggageCapacity: Int = 0) {
        self.vehicleClass = vehicleClass
        self.type = type
        self.tags = tags
        self.qta = qta
        self.passengerCapacity = passengerCapacity
        self.luggageCapacity = luggageCapacity
    }

    enum CodingKeys: String, CodingKey {
        case vehicleClass = "class"
        case type
        case tags
        case qta
        case passengerCapacity = "passenger_capacity"
        case luggageCapacity = "luggage_capacity"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.vehicleClass = (try? container.decodeIfPresent(String.self, forKey: .vehicleClass)) ?? ""
        self.type = (try? container.decodeIfPresent(String.self, forKey: .type)) ?? ""
        self.tags = (try? container.decodeIfPresent(Array.self, forKey: .tags)) ?? []
        self.qta = (try? container.decodeIfPresent(QuoteQta.self, forKey: .qta)) ?? QuoteQta()
        self.passengerCapacity = (try? container.decodeIfPresent(Int.self, forKey: .passengerCapacity)) ?? 0
        self.luggageCapacity = (try? container.decodeIfPresent(Int.self, forKey: .luggageCapacity)) ?? 0
    }
}
