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
}
