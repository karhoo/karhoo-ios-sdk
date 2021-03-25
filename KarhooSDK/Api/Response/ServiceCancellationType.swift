//
//  ServiceCancellationType.swift
//  KarhooSDK
//
//  Created by Corneliu on 25.03.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public enum ServiceCancellationType: KarhooCodableModel {

    case timeBeforePickup
    case beforeDriverEnRoute
    case other

    public init(from decoder: Decoder) throws {
        let typeString = try decoder.singleValueContainer().decode(String.self)
        switch typeString {
        case "BeforeDriverEnRoute":
            self = .beforeDriverEnRoute
        case "TimeBeforePickup":
            self = .timeBeforePickup
        default:
            self = .other
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .beforeDriverEnRoute:
            try container.encode("BeforeDriverEnRoute")
        case .timeBeforePickup:
            try container.encode("TimeBeforePickup")
        case .other:
            try container.encode("")
        }
    }
}
