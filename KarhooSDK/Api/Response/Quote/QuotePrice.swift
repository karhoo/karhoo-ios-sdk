//
//  QuotePrice.swift
//  KarhooSDK
//
//  Created by Jeevan Thandi on 16/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct QuotePrice: Codable {

    public let highPrice: Double
    public let lowPrice: Double
    public let currencyCode: String

    public init(highPrice: Double = 0,
                lowPrice: Double = 0,
                currencyCode: String = "") {
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.currencyCode = currencyCode
    }

    enum CodingKeys: String, CodingKey {
        case highPrice = "high"
        case lowPrice = "low"
        case currencyCode = "currency_code"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let intLowPrice: Int = (try? container.decode(Int.self, forKey: .lowPrice)) ?? 0
        self.lowPrice = Double(intLowPrice) * 0.01

        let intHighPrice: Int = (try? container.decode(Int.self, forKey: .lowPrice)) ?? 0
        self.highPrice = Double(intHighPrice) * 0.01

        self.currencyCode = (try? container.decode(String.self, forKey: .currencyCode)) ?? ""
    }
}
