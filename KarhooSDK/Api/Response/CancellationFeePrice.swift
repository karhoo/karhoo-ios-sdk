//
//  CancellationFeePrice.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 01/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct CancellationFeePrice: KarhooCodableModel {
    
    public let currency: String
    public let type: String
    public let value: Int
    public let decimalValue: Double

    public init(currency: String = "",
                type: String = "",
                value: Int = 0,
                decimalValue: Double = 0) {
        self.currency = currency
        self.type = type
        self.value = value
        self.decimalValue = decimalValue
    }

    enum CodingKeys: String, CodingKey {
        case currency
        case type
        case value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = (try? container.decode(String.self, forKey: .currency)) ?? ""
        self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
        self.value = (try? container.decode(Int.self, forKey: .value)) ?? 0
        self.decimalValue = Double(value) * 0.01
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currency, forKey: .currency)
        try container.encode(type, forKey: .type)
        try container.encode(value, forKey: .value)
    }
}

