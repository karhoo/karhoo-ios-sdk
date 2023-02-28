//
//  FleetRating.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 27/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct FleetRating: KarhooCodableModel {

    public let count: Int
    public let score: Int

    public init(count: Int = 0,
                score: Int = 0) {
        self.count = count
        self.score = score
    }

    enum CodingKeys: String, CodingKey {
        case count = "count"
        case score = "score"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = (try? container.decodeIfPresent(Int.self, forKey: .count)) ?? 0
        self.score = (try? container.decodeIfPresent(Int.self, forKey: .score)) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(count, forKey: .count)
        try container.encode(score, forKey: .score)
    }
}
