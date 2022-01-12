//
//  LoyaltyStatus.swift
//  KarhooSDK
//
//  Created by Edward Wilkins on 15/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct LoyaltyStatus: KarhooCodableModel {
    
    public let balance: Int
    public let canBurn: Bool
    public let canEarn: Bool
    
    public init(balance: Int = 0,
                canBurn: Bool = false,
                canEarn: Bool = false) {
        self.balance = balance
        self.canBurn = canBurn
        self.canEarn = canEarn
    }
    
    enum CodingKeys: String, CodingKey {
        case balance
        case canBurn = "can_burn"
        case canEarn = "can_earn"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.balance = (try? container.decode(Int.self, forKey: .balance)) ?? 0
        self.canBurn = (try? container.decode(Bool.self, forKey: .canBurn)) ?? false
        self.canEarn = (try? container.decode(Bool.self, forKey: .canEarn)) ?? false
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(balance, forKey: .balance)
        try container.encode(canBurn, forKey: .canBurn)
        try container.encode(canEarn, forKey: .canEarn)
    }
}
