//
//  AdyenPaymentMethod.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethod: KarhooCodableModel {
    public let brands: [String]
    public let details: [AdyenDetail]
    public let name: String
    public let supportsRecurring: Bool
    public let type: String
    
    public init(brands: [String] = [],
                details: [AdyenDetail] = [],
                name: String = "",
                supportsRecurring: Bool = false,
                type: String) {
        self.brands = brands
        self.details = details
        self.name = name
        self.supportsRecurring = supportsRecurring
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case brands
        case details
        case name
        case supportsRecurring
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.brands = (try? container.decode(Array.self, forKey: .brands)) ?? []
        self.details = (try? container.decode(Array.self, forKey: .details)) ?? []
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.supportsRecurring = (try? container.decode(Bool.self, forKey: .supportsRecurring)) ?? false
        self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(brands, forKey: .brands)
        try container.encode(details, forKey: .details)
        try container.encode(name, forKey: .name)
        try container.encode(supportsRecurring, forKey: .supportsRecurring)
        try container.encode(type, forKey: .type)
    }
}
