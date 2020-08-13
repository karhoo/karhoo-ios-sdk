//
//  InputDetail.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

public struct AdyenDetail: KarhooCodableModel {
    public let configuration: [String: String]
    public let key: String?
    public let items: [AdyenItem]
    public let name: String?
    public let type: String?
    public let value: String?
    
    public init(configuration: [String: String],
                items: [AdyenItem] = [],
                key: String? = "",
                name: String? = "",
                type: String? = "",
                value: String? = "") {
        self.configuration = configuration
        self.items = items
        self.key = key
        self.name = name
        self.type = type
        self.value = value
    }
    
    enum CodingKeys: String, CodingKey {
        case configuration
        case key
        case items
        case name
        case type
        case value
    }
}
