//
//  AdyenPaymentMethods.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethods: KarhooCodableModel {
    public let groups: [AdyenPaymentMethodsGroup]
    public let paymentMethods: [AdyenPaymentMethod]
    
    public init(groups: [AdyenPaymentMethodsGroup] = [],
                paymentMethods: [AdyenPaymentMethod] = []) {
        self.groups = groups
        self.paymentMethods = paymentMethods
    }
    
    enum CodingKeys: String, CodingKey {
        case groups
        case paymentMethods
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groups = (try? container.decode(Array.self, forKey: .groups)) ?? []
        self.paymentMethods = (try? container.decode(Array.self, forKey: .paymentMethods)) ?? []
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(groups, forKey: .groups)
        try container.encode(paymentMethods, forKey: .paymentMethods)
    }
}
