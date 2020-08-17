//
//  InputDetail.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

public struct AdyenDetail: KarhooCodableModel {
    public let configuration: [String: String]
    public let items: [AdyenItem]
    public let key: String
    public let optional: Bool
    public let type: String
    
    public init(configuration: [String: String],
                items: [AdyenItem] = [],
                key: String = "",
                optional: Bool = false,
                type: String = "") {
        self.configuration = configuration 
        self.items = items
        self.key = key
        self.optional = optional
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case configuration
        case key
        case items
        case optional
        case type
    }
}
