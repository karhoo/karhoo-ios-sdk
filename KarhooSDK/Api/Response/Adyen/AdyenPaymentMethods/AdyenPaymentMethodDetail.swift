//
//  AdyenPaymentMethod.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethodDetail: KarhooCodableModel {
    public let brands: [String]
    public let confuguration: [String: String]
    public let details: [AdyenDetail]
    public let fundingSource: String
    public let group: AdyenGroup
    public let name: String
    public let paymentMethodData: String
    public let supportsRecurring: Bool
    public let type: String
    
    public init(brands: [String] = [],
                confuguration: [String: String] = [:],
                details: [AdyenDetail] = [],
                fundingSource: String = "",
                group: AdyenGroup = AdyenGroup(),
                name: String = "",
                paymentMethodData: String = "",
                supportsRecurring: Bool = false,
                type: String = "") {
        self.brands = brands
        self.confuguration = confuguration
        self.details = details
        self.fundingSource = fundingSource
        self.group = group
        self.name = name
        self.paymentMethodData = paymentMethodData
        self.supportsRecurring = supportsRecurring
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case brands
        case confuguration
        case details
        case fundingSource
        case group
        case name
        case paymentMethodData
        case supportsRecurring
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.brands = (try? container.decode(Array.self, forKey: .brands)) ?? []
        self.confuguration = (try? container.decode(Dictionary.self, forKey: .confuguration)) ?? [:]
        self.details = (try? container.decode(Array.self, forKey: .details)) ?? []
        self.fundingSource = (try? container.decode(String.self, forKey: .fundingSource)) ?? ""
        self.group = (try? container.decode(AdyenGroup.self, forKey: .group)) ?? AdyenGroup()
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.paymentMethodData = (try? container.decode(String.self, forKey: .paymentMethodData)) ?? ""
        self.supportsRecurring = (try? container.decode(Bool.self, forKey: .supportsRecurring)) ?? false
        self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(brands, forKey: .brands)
        try container.encode(confuguration, forKey: .confuguration)
        try container.encode(details, forKey: .details)
        try container.encode(fundingSource, forKey: .fundingSource)
        try container.encode(group, forKey: .group)
        try container.encode(name, forKey: .name)
        try container.encode(paymentMethodData, forKey: .paymentMethodData)
        try container.encode(supportsRecurring, forKey: .supportsRecurring)
        try container.encode(type, forKey: .type)
    }
}
