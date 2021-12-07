//
//  LoyaltyNonce.swift
//  KarhooSDK
//
//  Created by Edward Wilkins on 16/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct LoyaltyNonce: KarhooCodableModel {
    
    public let loyaltyNonce: String
    
    public init(loyaltyNonce: String = "") {
        self.loyaltyNonce = loyaltyNonce
    }
    
    enum CodingKeys: String, CodingKey {
        case nonce
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.loyaltyNonce = (try? container.decode(String.self, forKey: .nonce)) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(loyaltyNonce, forKey: .nonce)
    }
}
