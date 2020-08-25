//
//  InputDetail.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenDetail: KarhooCodableModel {
    public let items: [AdyenItem]
    public let key: String
    public let optional: Bool
    public let type: String
    
    public init(items: [AdyenItem] = [],
                key: String = "",
                optional: Bool = false,
                type: String = "") {
        self.items = items
        self.key = key
        self.optional = optional
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case items
        case key
        case optional
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = (try? container.decode(Array.self, forKey: .items)) ?? []
        self.key = (try? container.decode(String.self, forKey: .key)) ?? ""
        self.optional = (try? container.decode(Bool.self, forKey: .optional)) ?? false
        self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
        try container.encode(key, forKey: .key)
        try container.encode(optional, forKey: .optional)
        try container.encode(type, forKey: .type)
    }
}
