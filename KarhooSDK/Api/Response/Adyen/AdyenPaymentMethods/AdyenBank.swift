//
//  AdyenBank.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 26/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenBank: KarhooCodableModel {
    public let bankAccountNumber: String
    public let bankCity: String
    public let bankLocationId: String
    public let bankName: String
    public let bic: String
    public let countryCode: String
    public let iban: String
    public let ownerName: String
    public let taxId: String
    
    public init(bankAccountNumber: String = "",
                bankCity: String = "",
                bankLocationId: String = "",
                bankName: String = "",
                bic: String = "",
                countryCode: String = "",
                iban: String = "",
                ownerName: String = "",
                taxId: String = "") {
        self.bankAccountNumber = bankAccountNumber
        self.bankCity = bankCity
        self.bankLocationId = bankLocationId
        self.bankName = bankName
        self.bic = bic
        self.countryCode = countryCode
        self.iban = iban
        self.ownerName = ownerName
        self.taxId = taxId
    }
    
    enum CodingKeys: String, CodingKey {
        case bankAccountNumber
        case bankCity
        case bankLocationId
        case bankName
        case bic
        case countryCode
        case iban
        case ownerName
        case taxId
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bankAccountNumber = (try? container.decode(String.self, forKey: .bankAccountNumber)) ?? ""
        self.bankCity = (try? container.decode(String.self, forKey: .bankCity)) ?? ""
        self.bankLocationId = (try? container.decode(String.self, forKey: .bankLocationId)) ?? ""
        self.bankName = (try? container.decode(String.self, forKey: .bankName)) ?? ""
        self.bic = (try? container.decode(String.self, forKey: .bic)) ?? ""
        self.countryCode = (try? container.decode(String.self, forKey: .countryCode)) ?? ""
        self.iban = (try? container.decode(String.self, forKey: .iban)) ?? ""
        self.ownerName = (try? container.decode(String.self, forKey: .ownerName)) ?? ""
        self.taxId = (try? container.decode(String.self, forKey: .taxId)) ?? ""
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bankAccountNumber, forKey: .bankAccountNumber)
        try container.encode(bankCity, forKey: .bankCity)
        try container.encode(bankLocationId, forKey: .bankLocationId)
        try container.encode(bankName, forKey: .bankName)
        try container.encode(bic, forKey: .bic)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(iban, forKey: .iban)
        try container.encode(ownerName, forKey: .ownerName)
        try container.encode(taxId, forKey: .taxId)
    }
}
