//
//  TripQuote.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct TripQuote: Codable {

    public let total: Int
    public let currency: String
    public let gratuityPercent: Int
    public let breakdown: [FareComponent?]
    public var denominateTotal: Double {
        return Double(total) * 0.01
    }
    public let qtaHighMinutes: Int
    public let qtaLowMinutes: Int
    public let type: QuoteType
    public let vehicleClass: String
    public let vehicleAttributes: VehicleAttributes

    public init(total: Int = 0,
                currency: String = "",
                gratuityPercent: Int = 0,
                breakdown: [FareComponent?] = [FareComponent()],
                qtaHighMinutes: Int = 0,
                qtaLowMinutes: Int = 0,
                type: QuoteType = .estimated,
                vehicleClass: String = "",
                vehicleAttributes: VehicleAttributes = VehicleAttributes()) {
        self.total = total
        self.currency = currency
        self.gratuityPercent = gratuityPercent
        self.breakdown = breakdown
        self.qtaHighMinutes = qtaHighMinutes
        self.qtaLowMinutes = qtaLowMinutes
        self.type = type
        self.vehicleClass = vehicleClass
        self.vehicleAttributes = vehicleAttributes
    }

    enum CodingKeys: String, CodingKey {
        case total
        case currency
        case gratuityPercent = "gratuity_percent"
        case breakdown
        case qtaHighMinutes = "qta_high_minutes"
        case qtaLowMinutes = "qta_low_minutes"
        case type
        case vehicleClass = "vehicle_class"
        case vehicleAttributes = "vehicle_attributes"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = (try? container.decode(Int.self, forKey: .total)) ?? 0
        self.currency = (try? container.decode(String.self, forKey: .currency)) ?? ""
        self.gratuityPercent = (try? container.decode(Int.self, forKey: .gratuityPercent)) ?? 0
        self.breakdown = (try? container.decode([FareComponent?].self, forKey: .breakdown)) ?? []
        self.qtaHighMinutes = (try? container.decode(Int.self, forKey: .qtaHighMinutes)) ?? 0
        self.qtaLowMinutes = (try? container.decode(Int.self, forKey: .qtaLowMinutes)) ?? 0
        self.type = (try? container.decode(QuoteType.self, forKey: .type)) ?? .estimated
        self.vehicleClass = (try? container.decode(String.self, forKey: .vehicleClass)) ?? ""
        self.vehicleAttributes = (try? container.decode(VehicleAttributes.self, forKey: .vehicleAttributes))
            ?? VehicleAttributes()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(total, forKey: .total)
        try container.encode(currency, forKey: .currency)
        try container.encode(gratuityPercent, forKey: .gratuityPercent)
        try container.encode(breakdown, forKey: .breakdown)
        try container.encode(qtaHighMinutes, forKey: .qtaHighMinutes)
        try container.encode(qtaLowMinutes, forKey: .qtaLowMinutes)
        try container.encode(type, forKey: .type)
        try container.encode(vehicleClass, forKey: .vehicleClass)
        try container.encode(vehicleAttributes, forKey: .vehicleAttributes)
    }
}
