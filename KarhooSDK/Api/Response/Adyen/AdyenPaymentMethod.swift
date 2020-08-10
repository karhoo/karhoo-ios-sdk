//
//  AdyenPaymentMethod.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethod: KarhooCodableModel {
    public let brands: [String]
    public let configuration: [String: String]
    public let details: [InputDetail]
    public let group: [Group]
    public let items: [Item]
    public let paymentMethodData: String
    public let supportsRecurring: Bool
    public let type: String
    
    public init(brands: [String] = [],
                configuration: [String: String] = [String: String](),
                details: [InputDetail] = [],
                group: [Group] = [],
                items: [Item] = [],
                paymentMethodData: String = "",
                supportsRecurring: Bool,
                type: String) {
        self.configuration = configuration
        self.brands = brands
        self.details = details
        self.group = group
        self.items = items
        self.paymentMethodData = paymentMethodData
        self.supportsRecurring = supportsRecurring
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case brands
        case configuration
        case details
        case group
        case items
        case paymentMethodData
        case supportsRecurring
        case type
    }
}
