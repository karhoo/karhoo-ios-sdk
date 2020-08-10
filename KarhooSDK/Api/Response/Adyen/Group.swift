//
//  Group.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct Group: KarhooCodableModel {
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
}
