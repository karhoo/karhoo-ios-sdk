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
    public let net: NetPrice

    public init(highPrice: Double = 0,
                lowPrice: Double = 0,
                currencyCode: String = "",
                net: NetPrice = NetPrice()) {
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.currencyCode = currencyCode
        self.net = net
    }

    enum CodingKeys: String, CodingKey {
        case highPrice = "high"
        case lowPrice = "low"
        case currencyCode = "currency_code"
        case net = "net"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        highPrice = (try? container.decode(Double.self, forKey: .highPrice)) ?? 0
        lowPrice = (try? container.decode(Double.self, forKey: .lowPrice)) ?? 0
        net = (try? container.decode(NetPrice.self, forKey: .net)) ?? NetPrice()
        currencyCode = (try? container.decode(String.self, forKey: .currencyCode)) ?? ""
    }
}
