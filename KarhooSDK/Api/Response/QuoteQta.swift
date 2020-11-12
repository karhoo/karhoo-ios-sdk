//
//  Qta.swift
//  KarhooSDK
//
//  Created by Jeevan Thandi on 16/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct QuoteQta: Codable {

    public let highMinutes: Int
    public let lowMinutes: Int

    public init(highMinutes: Int = 0,
                lowMinutes: Int = 0) {
        self.highMinutes = highMinutes
        self.lowMinutes = lowMinutes
    }

    enum CodingKeys: String, CodingKey {
        case highMinutes = "high_minutes"
        case lowMinutes = "low_minutes"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.highMinutes = (try? container.decode(Int.self, forKey: .highMinutes)) ?? 0
        self.lowMinutes = (try? container.decode(Int.self, forKey: .lowMinutes)) ?? 0
    }
}
