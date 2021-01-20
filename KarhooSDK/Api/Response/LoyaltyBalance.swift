//
//  LoyaltyBalance.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 17/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct LoyaltyBalance: KarhooCodableModel {

    public let points: Int
    public let burnable: Bool

    public init(points: Int = 0,
                burnable: Bool = false) {
        self.points = points
        self.burnable = burnable
    }

    enum CodingKeys: String, CodingKey {
        case points
        case burnable = "can_burn"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.points = (try? container.decode(Int.self, forKey: .points)) ?? 0
        self.burnable = (try? container.decode(Bool.self, forKey: .burnable)) ?? false
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(points, forKey: .points)
        try container.encode(burnable, forKey: .burnable)
    }
}
