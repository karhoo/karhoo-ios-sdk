//
//  Provider.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct PaymentProvider : KarhooCodableModel {
    public let provider: Provider
    public let version: String
    public let loyaltyProgamme: LoyaltyProgramme

    public init(provider: Provider = Provider(),
                version: String = "v51",
                loyaltyProgamme: LoyaltyProgramme = LoyaltyProgramme()) {
        self.provider = provider
        self.version = version
        self.loyaltyProgamme = loyaltyProgamme
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.provider = (try? container.decode(Provider.self, forKey: .provider)) ?? Provider()
        self.version = (try? container.decodeIfPresent(String.self, forKey: .version)) ?? "v51"
        self.loyaltyProgamme = (try? container.decode(LoyaltyProgramme.self, forKey: .loyaltyProgamme)) ?? LoyaltyProgramme()
    }
    
    enum CodingKeys: String, CodingKey {
        case provider
        case version
        case loyaltyProgamme = "loyalty_programme"
    }
}
