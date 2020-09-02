//
//  AdyenPaymentMethod.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 26/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethod: KarhooCodableModel {
    
    public let storedPaymentMethodId: String
    public let type: String
    
    
    
    public init(storedPaymentMethodId: String = "",
                type: String = "") {
        self.storedPaymentMethodId = storedPaymentMethodId
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case storedPaymentMethodId
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.storedPaymentMethodId = (try? container.decode(String.self, forKey: .storedPaymentMethodId)) ?? ""
        self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(storedPaymentMethodId, forKey: .storedPaymentMethodId)
        try container.encode(type, forKey: .type)
    }
}
