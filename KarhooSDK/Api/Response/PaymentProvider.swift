//
//  Provider.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct PaymentProvider : KarhooCodableModel {
    public let provider: Provider
    public let loyaltyProgamme: LoyaltyProgramme

    public init(provider: Provider = Provider(),
                loyaltyProgamme: LoyaltyProgramme = LoyaltyProgramme()) {
        self.provider = provider
        self.loyaltyProgamme = loyaltyProgamme
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.provider = (try? container.decode(Provider.self, forKey: .provider)) ?? Provider()
        self.loyaltyProgamme = (try? container.decode(LoyaltyProgramme.self, forKey: .loyaltyProgamme)) ?? LoyaltyProgramme()
    }
    
    enum CodingKeys: String, CodingKey {
        case provider
        case loyaltyProgamme = "loyalty_programme"
    }
}
