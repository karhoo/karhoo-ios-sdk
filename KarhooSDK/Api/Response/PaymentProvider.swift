//
//  Provider.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct PaymentProvider : KarhooCodableModel {
    public let id: String
    public let loyaltyProgammes: [LoyaltyProgramme]
    
    public init(id: String = "",
                loyaltyProgammes: [LoyaltyProgramme] = []) {
        self.id = id
        self.loyaltyProgammes = loyaltyProgammes
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = (try? container.decode(String.self, forKey: .id)) ?? ""
        self.loyaltyProgammes = (try? container.decode([LoyaltyProgramme].self, forKey: .loyaltyProgammes)) ?? []
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case loyaltyProgammes = "loyalty_programmes"
    }
}
