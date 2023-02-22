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
    public let version: String

    public var type: PaymentProviderType {
        switch self.id.lowercased() {
        case "braintree": return .braintree
        case "adyen": return .adyen
        default: return .unknown
        }
    }

    public init(id: String = "", version: String = "") {
        self.id = id
        self.version = version
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = (try? container.decodeIfPresent(String.self, forKey: .id)) ?? ""
        self.version = (try? container.decodeIfPresent(String.self, forKey: .version)) ?? "v51"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case version
    }
}
