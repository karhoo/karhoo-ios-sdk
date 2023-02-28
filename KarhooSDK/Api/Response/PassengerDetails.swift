//
//  PassengerDetails.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct PassengerDetails: KarhooCodableModel, Equatable {

    public let firstName: String
    public let lastName: String
    public let email: String
    public let phoneNumber: String
    public let locale: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case locale
    }

    public init(firstName: String = "",
                lastName: String = "",
                email: String = "",
                phoneNumber: String = "",
                locale: String = "") {

        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.locale = locale
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = (try? container.decodeIfPresent(String.self, forKey: .firstName)) ?? ""
        self.lastName = (try? container.decodeIfPresent(String.self, forKey: .lastName)) ?? ""
        self.email = (try? container.decodeIfPresent(String.self, forKey: .email)) ?? ""
        self.phoneNumber = (try? container.decodeIfPresent(String.self, forKey: .phoneNumber)) ?? ""
        self.locale = (try? container.decodeIfPresent(String.self, forKey: .locale)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(locale, forKey: .locale)
    }

}

public extension PassengerDetails {
    init(user: UserInfo) {
        self.init(firstName: user.firstName,
                lastName: user.lastName,
                email: user.email,
                phoneNumber: user.mobileNumber,
                locale: user.locale)
    }
}
