//
//  LoyaltyPoints.swift
//  KarhooSDK
//
//  Created by Edward Wilkins on 15/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct LoyaltyPoints: KarhooCodableModel {
    
    public let points: Int
    
    public init(points: Int = 0) {
        self.points = points
    }
    
    enum CodingKeys: String, CodingKey {
        case points
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.points = (try? container.decodeIfPresent(Int.self, forKey: .points)) ?? 0
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(points, forKey: .points)
    }
}
