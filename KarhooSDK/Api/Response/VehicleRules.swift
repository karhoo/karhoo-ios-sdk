//
//  VehicleRules.swift
//  KarhooSDK
//
//  Created by Aleksander Wedrychowski on 19/07/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct VehicleRules: Codable, KarhooCodableModel {
    public let rules: [VehicleRule]

    enum CodingKeys: String, CodingKey {
        case rules = "mappings"
    }
}

public struct VehicleRule: Codable {
    public let type: String
    public let tags: [String]
    public let imagePath: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case tags
        case imagePath = "image_png"
    }
}
