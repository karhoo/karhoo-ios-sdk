//
//  FleetInfo.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct FleetInfo: Codable {

    public let fleetId: String
    public let name: String
    public let logoUrl: String
    public let description: String
    public let phoneNumber: String
    public let termsConditionsUrl: String
    public let email: String

    public init(fleetId: String = "",
                name: String = "",
                description: String = "",
                phoneNumber: String = "",
                termsConditionsUrl: String = "",
                logoUrl: String = "",
                email: String = "") {
        self.fleetId = fleetId
        self.name = name
        self.logoUrl = logoUrl
        self.description = description
        self.phoneNumber = phoneNumber
        self.termsConditionsUrl = termsConditionsUrl
        self.email = email
    }

    enum CodingKeys: String, CodingKey {
        case fleetId = "fleet_id"
        case name
        case logoUrl = "logo_url"
        case description
        case phoneNumber = "phone_number"
        case termsConditionsUrl = "terms_conditions_url"
        case email
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fleetId = (try? container.decode(String.self, forKey: .fleetId)) ?? ""
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.logoUrl = (try? container.decode(String.self, forKey: .logoUrl)) ?? ""
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
        self.phoneNumber = (try? container.decode(String.self, forKey: .phoneNumber)) ?? ""
        self.termsConditionsUrl = (try? container.decode(String.self, forKey: .termsConditionsUrl)) ?? ""
        self.email = (try? container.decode(String.self, forKey: .email)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fleetId, forKey: .fleetId)
        try container.encode(name, forKey: .name)
        try container.encode(logoUrl, forKey: .logoUrl)
        try container.encode(description, forKey: .description)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(termsConditionsUrl, forKey: .termsConditionsUrl)
        try container.encode(email, forKey: .email)
    }
}
