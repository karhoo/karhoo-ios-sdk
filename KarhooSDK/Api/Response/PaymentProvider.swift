//
//  Provider.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct PaymentProvider : KarhooCodableModel {
    public let provider: Provider
    public let loyaltyProgammes: [LoyaltyProgramme]
    public let loyaltyProgamme: LoyaltyProgramme

    public init(provider: Provider = Provider(),
                loyaltyProgammes: [LoyaltyProgramme] = [],
                loyaltyProgamme: LoyaltyProgramme = LoyaltyProgramme()) {
        self.provider = provider
        self.loyaltyProgammes = loyaltyProgammes
        self.loyaltyProgamme = loyaltyProgamme
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.provider = (try? container.decode(Provider.self, forKey: .provider)) ?? Provider()
        self.loyaltyProgammes = (try? container.decode([LoyaltyProgramme].self, forKey: .loyaltyProgammes)) ?? []
        self.loyaltyProgamme = (try? container.decode(LoyaltyProgramme.self, forKey: .loyaltyProgamme)) ?? LoyaltyProgramme()
    }
    
    enum CodingKeys: String, CodingKey {
        case provider
        case loyaltyProgammes = "loyalty_programmes"
        case loyaltyProgamme = "loyalty_programme"
    }
}
