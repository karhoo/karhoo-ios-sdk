//
//  Provider.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct PaymentProvider : KarhooCodableModel {
    public let provider: Provider
    public let loyaltyProgammes: LoyaltyProgramme

    public init(provider: Provider = Provider(),
                loyaltyProgammes: LoyaltyProgramme = LoyaltyProgramme()) {
        self.provider = provider
        self.loyaltyProgammes = loyaltyProgammes
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.provider = (try? container.decode(Provider.self, forKey: .provider)) ?? Provider()
        self.loyaltyProgammes = (try? container.decode(LoyaltyProgramme.self, forKey: .loyaltyProgammes)) ?? LoyaltyProgramme()
    }
    
    enum CodingKeys: String, CodingKey {
        case provider
        case loyaltyProgammes = "loyalty_programmes"
    }
}
