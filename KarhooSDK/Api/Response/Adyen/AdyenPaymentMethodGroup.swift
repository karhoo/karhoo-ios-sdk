//
//  AdyenPaymentMethodGroup.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethodGroup: KarhooCodableModel {
    public let groupType: String
    public let name: String
    public let types: [String]
        
    public init(groupType: String = "",
                name: String = "",
                types: [String] = []) {
        self.groupType = groupType
        self.name = name
        self.types = types
    }
}
