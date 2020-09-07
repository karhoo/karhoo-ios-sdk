//
//  AdyenAmount.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 25/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenAmount: KarhooCodableModel {
    
    public let currency: String
    public let value: Double
    
    public init(currency: String = "",
                value: Double = 0) {
        self.currency = currency
        self.value = value
    }
    
    enum CodingKeys: String, CodingKey {
        case currency
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = (try? container.decode(String.self, forKey: .currency)) ?? ""
        self.value = (try? container.decode(Double.self, forKey: .value)) ?? 0.0
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currency, forKey: .currency)
        try container.encode(value, forKey: .value)
    }
}
