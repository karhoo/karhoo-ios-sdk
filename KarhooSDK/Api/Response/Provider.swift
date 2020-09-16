//
//  Provider.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public enum PaymentProviderType {
    case braintree, adyen, unknown
}

public struct Provider: KarhooCodableModel {
    public let id: String

    public var type: PaymentProviderType {
        switch self.id.lowercased() {
        case "braintree": return .braintree
        case "adyen": return .adyen
        default: return .unknown
        }
    }

    public init(id: String = "") {
        self.id = id
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = (try? container.decode(String.self, forKey: .id)) ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
    }
}
