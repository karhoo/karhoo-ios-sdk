//
//  AdyenPaymentMethodGroup.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethodsGroup: KarhooCodableModel {
    public let groupType: String
    public let name: String
    public let types: [String]
    
    public init(groupType: String = "",
                name: String = "",
                types: [String] = []) {
        self.groupType = groupType
        self.name = name
        self.types = types
    }
    
    enum CodingKeys: String, CodingKey {
        case groupType
        case name
        case types
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groupType = (try? container.decode(String.self, forKey: .groupType)) ?? ""
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.types = (try? container.decode(Array.self, forKey: .types)) ?? []
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(groupType, forKey: .groupType)
        try container.encode(name, forKey: .name)
        try container.encode(types, forKey: .types)
    }
}
