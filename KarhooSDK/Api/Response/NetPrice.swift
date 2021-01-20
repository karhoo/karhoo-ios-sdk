//
//  NetPrice.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 27/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct NetPrice: KarhooCodableModel {

    public let high: Int
    public let low: Int

    public init(high: Int = 0,
                low: Int = 0) {
        self.high = high
        self.low = low
    }

    enum CodingKeys: String, CodingKey {
        case high = "high"
        case low = "low"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.high = (try? container.decode(Int.self, forKey: .high)) ?? 0
        self.low = (try? container.decode(Int.self, forKey: .low)) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(high, forKey: .high)
        try container.encode(low, forKey: .low)
    }
}
