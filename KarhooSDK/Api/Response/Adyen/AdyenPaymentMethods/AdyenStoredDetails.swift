//
//  AdyenStoredDetails.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 26/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenStoredDetails: KarhooCodableModel {
    public let bank: AdyenBank
    public let card: AdyenCard
    public let emailAddress: String
    
    public init(bank: AdyenBank = AdyenBank(),
                card: AdyenCard = AdyenCard(),
                emailAddress: String = "") {
        self.bank = bank
        self.card = card
        self.emailAddress = emailAddress
    }
    
    enum CodingKeys: String, CodingKey {
        case bank
        case card
        case emailAddress
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bank = (try? container.decode(AdyenBank.self, forKey: .bank)) ?? AdyenBank()
        self.card = (try? container.decode(AdyenCard.self, forKey: .card)) ?? AdyenCard()
        self.emailAddress = (try? container.decode(String.self, forKey: .emailAddress)) ?? ""
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bank, forKey: .bank)
        try container.encode(card, forKey: .card)
        try container.encode(emailAddress, forKey: .emailAddress)
    }
}


