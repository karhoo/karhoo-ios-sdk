//
//  AdyenPaymentMethods.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethods: KarhooCodableModel {
    public let groups: [AdyenPaymentMethodGroup]
    public let paymentMethods: [AdyenPaymentMethod]
    
    public init(groups: [AdyenPaymentMethodGroup] = [],
                paymentMethods: [AdyenPaymentMethod] = []) {
        self.groups = groups
        self.paymentMethods = paymentMethods
    }
    
    enum CodingKeys: String, CodingKey {
        case groups
        case paymentMethods
    }
}
