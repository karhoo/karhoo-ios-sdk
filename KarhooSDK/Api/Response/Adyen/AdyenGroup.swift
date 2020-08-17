//
//  Group.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenGroup: KarhooCodableModel {
    public let name: String
    public let paymentMethodData: String
    public let type: String
    
    public init(name: String = "",
                paymentMethodData: String = "",
                type: String = "") {
        self.name = name
        self.paymentMethodData = paymentMethodData
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case paymentMethodData
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""   
        self.paymentMethodData = (try? container.decode(String.self, forKey: .paymentMethodData)) ?? ""
        self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(paymentMethodData, forKey: .paymentMethodData)
        try container.encode(type, forKey: .type)
    }
}
