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
    
    // Server side price format
        public let intHighPrice: Int
        public let intLowPrice: Int

    public init(highPrice: Double = 0,
                lowPrice: Double = 0,
                currencyCode: String = "",
                net: NetPrice = NetPrice(),
                intLowPrice: Int = 0,
                intHighPrice: Int = 0) {
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.currencyCode = currencyCode
        self.net = net
        self.intLowPrice = intLowPrice
        self.intHighPrice = intHighPrice
    }

    enum CodingKeys: String, CodingKey {
        case highPrice = "high"
        case lowPrice = "low"
        case currencyCode = "currency_code"
        case net = "net"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        intLowPrice = (try? container.decode(Int.self, forKey: .lowPrice)) ?? 0
        lowPrice = Double(intLowPrice) * 0.01
        
        intHighPrice = (try? container.decode(Int.self, forKey: .highPrice)) ?? 0
        highPrice = Double(intHighPrice) * 0.01
        
        net = (try? container.decode(NetPrice.self, forKey: .net)) ?? NetPrice()
        currencyCode = (try? container.decode(String.self, forKey: .currencyCode)) ?? ""  
    }
}
