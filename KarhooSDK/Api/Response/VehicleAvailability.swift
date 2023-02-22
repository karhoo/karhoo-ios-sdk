//
//  VehicleAvailability.swift
//  KarhooSDK
//
//  Created by Jeevan Thandi on 15/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct VehicleAvailability: KarhooCodableModel {

    public let classes: [String]
    public let types: [String]
    public let tags: [String]

    public init(classes: [String] = [],
                types: [String] = [],
                tags: [String] = []) {
        self.classes = classes
        self.types = types
        self.tags = tags
    }

    enum CodingKeys: String, CodingKey {
        case classes
        case types
        case tags
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.classes = (try? container.decodeIfPresent(Array.self, forKey: .classes)) ?? []
        self.types = (try? container.decodeIfPresent(Array.self, forKey: .types)) ?? []
        self.tags = (try? container.decodeIfPresent(Array.self, forKey: .tags)) ?? []
    }
}
