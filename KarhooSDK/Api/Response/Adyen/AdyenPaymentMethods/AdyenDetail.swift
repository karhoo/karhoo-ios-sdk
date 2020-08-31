//
//  InputDetail.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenDetail: KarhooCodableModel {
    public let confuguration: [String: String]
    public let items: [AdyenItem]
    public let key: String
    public let optional: Bool
    public let type: String
    public let value: String
    
    public init(items: [AdyenItem] = [],
                confuguration: [String: String] = [:],
                key: String = "",
                optional: Bool = false,
                type: String = "",
                value: String = "") {
        self.items = items
        self.confuguration = confuguration
        self.key = key
        self.optional = optional
        self.type = type
        self.value = value
    }
    
    enum CodingKeys: String, CodingKey {
        case confuguration
        case items
        case key
        case optional
        case type
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.confuguration = (try? container.decode(Dictionary.self, forKey: .confuguration)) ?? [:]
        self.items = (try? container.decode(Array.self, forKey: .items)) ?? []
        self.key = (try? container.decode(String.self, forKey: .key)) ?? ""
        self.optional = (try? container.decode(Bool.self, forKey: .optional)) ?? false
        self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
        self.value = (try? container.decode(String.self, forKey: .value)) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(confuguration, forKey: .confuguration)
        try container.encode(items, forKey: .items)
        try container.encode(key, forKey: .key)
        try container.encode(optional, forKey: .optional)
        try container.encode(type, forKey: .type)
        try container.encode(value, forKey: .value)
    }
}
