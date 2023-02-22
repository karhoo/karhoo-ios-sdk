//
//  Driver.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Driver: Codable {

    public let firstName: String
    public let lastName: String
    public let phoneNumber: String
    public let photoUrl: String
    public let licenseNumber: String

    public init(firstName: String = "",
                lastName: String = "",
                phoneNumber: String = "",
                photoUrl: String = "",
                licenseNumber: String = "") {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.photoUrl = photoUrl
        self.licenseNumber = licenseNumber
    }

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case photoUrl = "photo_url"
        case licenseNumber = "license_number"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = (try? container.decodeIfPresent(String.self, forKey: .firstName)) ?? ""
        self.lastName = (try? container.decodeIfPresent(String.self, forKey: .lastName)) ?? ""
        self.phoneNumber = (try? container.decodeIfPresent(String.self, forKey: .phoneNumber)) ?? ""
        self.photoUrl = (try? container.decodeIfPresent(String.self, forKey: .photoUrl)) ?? ""
        self.licenseNumber = (try? container.decodeIfPresent(String.self, forKey: .licenseNumber)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(photoUrl, forKey: .photoUrl)
        try container.encode(licenseNumber, forKey: .licenseNumber)
    }
}
