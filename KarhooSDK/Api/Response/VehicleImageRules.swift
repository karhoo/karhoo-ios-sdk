//
//  VehicleRules.swift
//  KarhooSDK
//
//  Created by Aleksander Wedrychowski on 19/07/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct VehicleImageRules: Codable, KarhooCodableModel {
    public let rules: [VehicleImageRule]

    enum CodingKeys: String, CodingKey {
        case rules = "mappings"
    }
}

public struct VehicleImageRule: Codable {
    public let type: String
    public let tags: [String]
    public let imagePath: String

    /// Default rule. Should be used as fallback other rules do not mach.
    public var isDefault: Bool { type == "*"}

    enum CodingKeys: String, CodingKey {
        case type
        case tags
        case imagePath = "image_png"
    }
}
