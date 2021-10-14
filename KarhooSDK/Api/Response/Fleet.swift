//
//  Fleet.swift
//  KarhooSDK
//
//  Created by Mostafa Hadian on 11/03/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct Fleet: Codable {

    public let id: String
    public let name: String
    public let logoUrl: String
    public let description: String
    public let phoneNumber: String
    public let termsConditionsUrl: String
    public let capability: [String]
    public let rating: FleetRating

    public init(id: String = "",
                name: String = "",
                description: String = "",
                phoneNumber: String = "",
                termsConditionsUrl: String = "",
                logoUrl: String = "",
                capability: [String] = [],
                rating: FleetRating = FleetRating()) {
        self.id = id
        self.name = name
        self.logoUrl = logoUrl
        self.description = description
        self.phoneNumber = phoneNumber
        self.termsConditionsUrl = termsConditionsUrl
        self.capability = capability
        self.rating = rating
        
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoUrl = "logo_url"
        case description
        case phoneNumber = "phone_number"
        case termsConditionsUrl = "terms_conditions_url"
        case capability = "capabilities"
        case rating
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(String.self, forKey: .id)) ?? ""
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.logoUrl = (try? container.decode(String.self, forKey: .logoUrl)) ?? ""
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
        self.phoneNumber = (try? container.decode(String.self, forKey: .phoneNumber)) ?? ""
        self.termsConditionsUrl = (try? container.decode(String.self, forKey: .termsConditionsUrl)) ?? ""
        self.capability = (try? container.decode(Array.self, forKey: .capability)) ?? []
        self.rating = (try? container.decode(FleetRating.self, forKey: .rating)) ?? FleetRating()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(logoUrl, forKey: .logoUrl)
        try container.encode(description, forKey: .description)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(termsConditionsUrl, forKey: .termsConditionsUrl)
        try container.encode(capability, forKey: .capability)
        try container.encode(rating, forKey: .rating)
    }
}
