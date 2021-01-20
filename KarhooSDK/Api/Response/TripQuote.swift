//
//  TripQuote.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct TripQuote: Codable {

    @available(*, deprecated, message: "quote.total is deprecated in the Quote API")
    public let total: Int
    public let currency: String
    public let gratuityPercent: Int
    @available(*, deprecated, message: "quote.breakdown is deprecated in the Quote API")
    public let breakdown: [FareComponent?]
    @available(*, deprecated, message: "quote.denominateTotal is deprecated in the Quote API")
    public var denominateTotal: Double {
        return Double(total) * 0.01
    }
    public let qtaHighMinutes: Int
    public let qtaLowMinutes: Int
    public let highPrice: Int
    public let lowPrice: Int
    public let type: QuoteType
    public let vehicleClass: String

    public init(total: Int = 0,
                currency: String = "",
                gratuityPercent: Int = 0,
                breakdown: [FareComponent?] = [FareComponent()],
                qtaHighMinutes: Int = 0,
                qtaLowMinutes: Int = 0,
                highPrice: Int = 0,
                lowPrice: Int = 0,
                type: QuoteType = .estimated,
                vehicleClass: String = "") {
        self.total = total
        self.currency = currency
        self.gratuityPercent = gratuityPercent
        self.breakdown = breakdown
        self.qtaHighMinutes = qtaHighMinutes
        self.qtaLowMinutes = qtaLowMinutes
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.type = type
        self.vehicleClass = vehicleClass
    }

    enum CodingKeys: String, CodingKey {
        case total
        case currency
        case gratuityPercent = "gratuity_percent"
        case breakdown
        case qtaHighMinutes = "qta_high_minutes"
        case qtaLowMinutes = "qta_low_minutes"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case type
        case vehicleClass = "vehicle_class"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = (try? container.decode(Int.self, forKey: .total)) ?? 0
        self.currency = (try? container.decode(String.self, forKey: .currency)) ?? ""
        self.gratuityPercent = (try? container.decode(Int.self, forKey: .gratuityPercent)) ?? 0
        self.breakdown = (try? container.decode([FareComponent?].self, forKey: .breakdown)) ?? []
        self.qtaHighMinutes = (try? container.decode(Int.self, forKey: .qtaHighMinutes)) ?? 0
        self.qtaLowMinutes = (try? container.decode(Int.self, forKey: .qtaLowMinutes)) ?? 0
        self.highPrice = (try? container.decode(Int.self, forKey: .highPrice)) ?? 0
        self.lowPrice = (try? container.decode(Int.self, forKey: .lowPrice)) ?? 0
        self.type = (try? container.decode(QuoteType.self, forKey: .type)) ?? .estimated
        self.vehicleClass = (try? container.decode(String.self, forKey: .vehicleClass)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(total, forKey: .total)
        try container.encode(currency, forKey: .currency)
        try container.encode(gratuityPercent, forKey: .gratuityPercent)
        try container.encode(breakdown, forKey: .breakdown)
        try container.encode(qtaHighMinutes, forKey: .qtaHighMinutes)
        try container.encode(qtaLowMinutes, forKey: .qtaLowMinutes)
        try container.encode(highPrice, forKey: .highPrice)
        try container.encode(lowPrice, forKey: .lowPrice)
        try container.encode(type, forKey: .type)
        try container.encode(vehicleClass, forKey: .vehicleClass)
    }
}
