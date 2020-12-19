//
//  LoyaltyRates.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 18/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct LoyaltyRates: KarhooCodableModel {

    public let currency: String
    public let points: String

    public init(currency: String = "",
                points: String = "") {
        self.currency = currency
        self.points = points
    }

    enum CodingKeys: String, CodingKey {
        case currency
        case points
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = (try? container.decode(String.self, forKey: .currency)) ?? ""
        self.points = (try? container.decode(String.self, forKey: .points)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currency, forKey: .currency)
        try container.encode(points, forKey: .points)
    }
}
