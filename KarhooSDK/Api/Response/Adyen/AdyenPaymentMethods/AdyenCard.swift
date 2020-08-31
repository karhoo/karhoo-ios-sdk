//
//  AdyenCard.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 26/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenCard: KarhooCodableModel {
    public let cvc: String
    public let expiryMonth: String
    public let expiryYear: String
    public let holderName: String
    public let issueNumber: String
    public let number: String
    public let startMonth: String
    public let startYear: String
    
    public init(cvc: String = "",
                expiryMonth: String = "",
                expiryYear: String = "",
                holderName: String = "",
                issueNumber: String = "",
                number: String = "",
                startMonth: String = "",
                startYear: String = "") {
        self.cvc = cvc
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.holderName = holderName
        self.issueNumber = issueNumber
        self.number = number
        self.startMonth = startMonth
        self.startYear = startYear
    }
    
    enum CodingKeys: String, CodingKey {
        case cvc
        case expiryMonth
        case expiryYear
        case holderName
        case issueNumber
        case number
        case startMonth
        case startYear
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cvc = (try? container.decode(String.self, forKey: .cvc)) ?? ""
        self.expiryMonth = (try? container.decode(String.self, forKey: .expiryMonth)) ?? ""
        self.expiryYear = (try? container.decode(String.self, forKey: .expiryYear)) ?? ""
        self.holderName = (try? container.decode(String.self, forKey: .holderName)) ?? ""
        self.issueNumber = (try? container.decode(String.self, forKey: .issueNumber)) ?? ""
        self.number = (try? container.decode(String.self, forKey: .number)) ?? ""
        self.startMonth = (try? container.decode(String.self, forKey: .startMonth)) ?? ""
        self.startYear = (try? container.decode(String.self, forKey: .startYear)) ?? ""
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cvc, forKey: .cvc)
        try container.encode(expiryMonth, forKey: .expiryMonth)
        try container.encode(expiryYear, forKey: .expiryYear)
        try container.encode(holderName, forKey: .holderName)
        try container.encode(issueNumber, forKey: .issueNumber)
        try container.encode(number, forKey: .number)
        try container.encode(startMonth, forKey: .startMonth)
        try container.encode(startYear, forKey: .startYear)
    }
}
