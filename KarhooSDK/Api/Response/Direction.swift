//
//  Direction.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 08/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct Direction: KarhooCodableModel, Equatable {

    public let kph: Int
    public let heading: Int

    public init(kph: Int = 0,
                heading: Int = 0) {
        self.kph = kph
        self.heading = heading
    }

    enum CodingKeys: String, CodingKey {
        case kph
        case heading
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kph = (try? container.decodeIfPresent(Int.self, forKey: .kph)) ?? 0
        self.heading = (try? container.decodeIfPresent(Int.self, forKey: .heading)) ?? 0
    }
}
