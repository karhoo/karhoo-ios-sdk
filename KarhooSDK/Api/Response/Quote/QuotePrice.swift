//
//  QuotePrice.swift
//  KarhooSDK
//
//  Created by Jeevan Thandi on 16/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct QuotePrice: Codable {

    public let highPrice: Int
    public let lowPrice: Int
    public let currencyCode: String

    public init(highPrice: Int = 0,
                lowPrice: Int = 0,
                currencyCode: String = "") {
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.currencyCode = currencyCode
    }

    enum CodingKeys: String, CodingKey {
        case highPrice = "high_minutes"
        case lowPrice = "low_minutes"
        case currencyCode = "currency_code"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.highPrice = (try? container.decode(Int.self, forKey: .highPrice)) ?? 0
        self.lowPrice = (try? container.decode(Int.self, forKey: .lowPrice)) ?? 0
        self.currencyCode = (try? container.decode(String.self, forKey: .currencyCode)) ?? ""
    }
}
