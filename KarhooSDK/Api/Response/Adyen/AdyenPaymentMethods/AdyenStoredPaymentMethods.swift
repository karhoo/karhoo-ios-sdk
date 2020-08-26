//
//  AdyenStoredPaymentMethods.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 26/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenStoredPaymentMethods: KarhooCodableModel {
    public let brands: String
    public let expiryMonth: String
    public let expiryYear: String
    public let holderName: String
    public let id: String
    public let lastFour: String
    public let name: String
    public let shopperEmail: String
    public let supportedShopperInteractions: [String]
    public let type: String
    
    public init(brands: String = "",
                expiryMonth: String = "",
                expiryYear: String = "",
                holderName: String = "",
                id: String = "",
                lastFour: String = "",
                name: String = "",
                shopperEmail: String = "",
                supportedShopperInteractions: [String] = [],
                type: String = "") {
        self.brands = brands
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.holderName = holderName
        self.id = id
        self.lastFour = lastFour
        self.name = name
        self.shopperEmail = shopperEmail
        self.supportedShopperInteractions = supportedShopperInteractions
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
         case brands
         case expiryMonth
         case expiryYear
         case holderName
         case id
         case lastFour
         case name
         case shopperEmail
         case supportedShopperInteractions
         case type
    }
    
    public init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
        self.brands = (try? container.decode(String.self, forKey: .brands)) ?? ""
        self.expiryMonth = (try? container.decode(String.self, forKey: .expiryMonth)) ?? ""
        self.expiryYear = (try? container.decode(String.self, forKey: .expiryYear)) ?? ""
        self.holderName = (try? container.decode(String.self, forKey: .holderName)) ?? ""
        self.id = (try? container.decode(String.self, forKey: .id)) ?? ""
        self.lastFour = (try? container.decode(String.self, forKey: .lastFour)) ?? ""
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.shopperEmail = (try? container.decode(String.self, forKey: .shopperEmail)) ?? ""
        self.supportedShopperInteractions = (try? container.decode(Array.self, forKey: .supportedShopperInteractions)) ?? []
        self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
        
       }

       public func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(brands, forKey: .brands)
        try container.encode(expiryMonth, forKey: .expiryMonth)
        try container.encode(expiryYear, forKey: .expiryYear)
        try container.encode(holderName, forKey: .holderName)
        try container.encode(id, forKey: .id)
        try container.encode(lastFour, forKey: .lastFour)
        try container.encode(name, forKey: .name)
        try container.encode(shopperEmail, forKey: .shopperEmail)
        try container.encode(supportedShopperInteractions, forKey: .supportedShopperInteractions)
        try container.encode(type, forKey: .type)
       }
}
