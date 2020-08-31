//
//  AdyenPaymentMethods.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethods: KarhooCodableModel {
    public let groups: [AdyenPaymentMethodsGroup]
    public let oneClickPaymentMethods: [AdyenOneClickPaymentMethods]
    public let paymentMethods: [AdyenPaymentMethodDetail]
    public let storedPaymentMethods: [AdyenStoredPaymentMethods]
    
    public init(groups: [AdyenPaymentMethodsGroup] = [],
                oneClickPaymentMethods: [AdyenOneClickPaymentMethods] = [],
                paymentMethods: [AdyenPaymentMethodDetail] = [],
                storedPaymentMethods: [AdyenStoredPaymentMethods] = []) {
        self.groups = groups
        self.oneClickPaymentMethods = oneClickPaymentMethods
        self.paymentMethods = paymentMethods
        self.storedPaymentMethods = storedPaymentMethods
    }
    
    enum CodingKeys: String, CodingKey {
        case groups
        case oneClickPaymentMethods
        case paymentMethods
        case storedPaymentMethods
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groups = (try? container.decode(Array.self, forKey: .groups)) ?? []
        self.oneClickPaymentMethods = (try? container.decode(Array.self, forKey: .oneClickPaymentMethods)) ?? []
        self.paymentMethods = (try? container.decode(Array.self, forKey: .paymentMethods)) ?? []
        self.storedPaymentMethods = (try? container.decode(Array.self, forKey: .storedPaymentMethods)) ?? []
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(groups, forKey: .groups)
        try container.encode(oneClickPaymentMethods, forKey: .oneClickPaymentMethods)
        try container.encode(paymentMethods, forKey: .paymentMethods)
        try container.encode(storedPaymentMethods, forKey: .storedPaymentMethods)
    }
}
