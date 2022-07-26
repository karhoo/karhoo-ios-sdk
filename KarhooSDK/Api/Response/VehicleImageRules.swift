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
    
    private static let fallbackRuleValue = "*"

    public enum RuleType {
        /// Rule that should be used when the vehicle type and tags match perfectly the ones in the quote.
        case specific
        /// Default rule for a given vehicle type. If the quote does not contain vehicle tags, then this rule should be used.
        case typeDefault
        /// Rule that is general fallback if any other rule doesn't mach given vehicle.
        case fallback
    }
    public let type: String
    public let tags: [String]
    public let imagePath: String

    /// How a rule should be treated by front ent system.
    public var ruleType: RuleType {
        if type == VehicleImageRule.fallbackRuleValue {
            return .fallback
        } else if tags.isEmpty == true {
            return .typeDefault
        } else {
            return .specific
        }
    }

    enum CodingKeys: String, CodingKey {
        case type
        case tags
        case imagePath = "image_png"
    }
}
