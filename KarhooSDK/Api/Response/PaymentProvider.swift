//
//  Provider.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct PaymentProvider : KarhooCodableModel {
    public let provider: Provider
    
    public init(provider: Provider = Provider()) {
        self.provider = provider
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.provider = (try? container.decode(Provider.self, forKey: .provider)) ?? Provider()
    }
    
    enum CodingKeys: String, CodingKey {
        case provider
    }
}
