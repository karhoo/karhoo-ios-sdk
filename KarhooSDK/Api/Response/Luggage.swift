//
//  Luggage.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 07/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct Luggage: KarhooCodableModel {

    public let total: Int

    public init(total: Int = 0) {
        self.total = total
    }

    enum CodingKeys: String, CodingKey {
        case total
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = (try? container.decodeIfPresent(Int.self, forKey: .total)) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(total, forKey: .total)
    }
}
