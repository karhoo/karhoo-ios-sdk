//
//  TripFare.swift
//  Analytics
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct TripFare: KarhooCodableModel {
    
    public let total: Int
    public let currency: String
    public let gratuityPercent: Int
    public var denominateTotal: Double {
        return Double(total) * 0.01
    }

    public init(total: Int = 0,
                currency: String = "",
                gratuityPercent: Int = 0) {
        self.total = total
        self.currency = currency
        self.gratuityPercent = gratuityPercent
    }

    enum CodingKeys: String, CodingKey {
        case total
        case currency
        case gratuityPercent = "gratuity_percent"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = (try? container.decode(Int.self, forKey: .total)) ?? 0
        self.currency = (try? container.decode(String.self, forKey: .currency)) ?? ""
        self.gratuityPercent = (try? container.decode(Int.self, forKey: .gratuityPercent)) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(total, forKey: .total)
        try container.encode(currency, forKey: .currency)
        try container.encode(gratuityPercent, forKey: .gratuityPercent)
    }
}
