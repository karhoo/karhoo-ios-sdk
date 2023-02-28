//
//  FareComponent.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct FareComponent: Codable, Equatable {

    public let total: Double
    public let currency: String

    public init(total: Double = 0.0,
                currency: String = "") {
        self.total = total
        self.currency = currency
    }

    enum CodingKeys: String, CodingKey {
        case total
        case currency
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.total = (try? container.decodeIfPresent(Double.self, forKey: .total)) ?? 0.0
        self.currency = (try? container.decodeIfPresent(String.self, forKey: .currency)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(total, forKey: .total)
        try container.encode(currency, forKey: .currency)
    }
}
