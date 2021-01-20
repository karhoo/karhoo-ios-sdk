//
//  LoyaltyConversion.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 18/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct LoyaltyConversion: KarhooCodableModel {

    public let version: String
    public let rates: [LoyaltyRates]

    public init(version: String = "",
                rates: [LoyaltyRates] = [LoyaltyRates()]) {
        self.version = version
        self.rates = rates
    }

    enum CodingKeys: String, CodingKey {
        case version
        case rates
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.version = (try? container.decode(String.self, forKey: .version)) ?? ""
        self.rates = (try? container.decode([LoyaltyRates].self, forKey: .rates)) ?? []
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(rates, forKey: .rates)
    }
}
