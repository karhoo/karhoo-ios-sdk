//
//  UserInfo.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct UserInfo: KarhooCodableModel, Equatable {

    public let userId: String
    public let firstName: String
    public let lastName: String
    public let email: String
    public let mobileNumber: String
    public let locale: String
    public let metadata: String
    public let organisations: [Organisation]
    public let primaryOrganisationID: String
    public let avatarURL: String
    public var nonce: Nonce?
    public var paymentProvider: PaymentProvider?
    public let externalId: String
    
    public init(userId: String = "",
                firstName: String = "",
                lastName: String = "",
                email: String = "",
                mobileNumber: String = "",
                organisations: [Organisation] = [],
                nonce: Nonce? = nil,
                paymentProvider: PaymentProvider? = nil,
                locale: String = "",
                externalId: String = "") {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.mobileNumber = mobileNumber
        self.locale = ""
        self.metadata = ""
        self.organisations = organisations
        self.primaryOrganisationID = ""
        self.avatarURL = ""
        self.nonce = nonce
        self.externalId = externalId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.userId = try container.decode(String.self, forKey: .userId)
        self.firstName = (try? container.decode(String.self, forKey: .firstName)) ?? ""
        self.lastName = (try? container.decode(String.self, forKey: .lastName)) ?? ""
        self.email = (try? container.decode(String.self, forKey: .email)) ?? ""
        self.mobileNumber = (try? container.decode(String.self, forKey: .mobileNumber)) ?? ""
        self.locale = (try? container.decode(String.self, forKey: .locale)) ?? ""
        self.metadata = (try? container.decode(String.self, forKey: .metadata)) ?? ""
        self.organisations = (try? container.decode([Organisation].self, forKey: .organisations)) ?? []
        self.primaryOrganisationID = (try? container.decode(String.self, forKey: .primaryOrganisationID)) ?? ""
        self.avatarURL = (try? container.decode(String.self, forKey: .avatarURL)) ?? ""
        self.nonce = (try? container.decode(Nonce.self, forKey: .nonce)) ?? nil
        self.paymentProvider = (try? container.decode(PaymentProvider.self, forKey: .paymentProvider)) ?? nil
        if container.contains(.upstream) {
            let upstream = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .upstream)
            self.externalId = (try? upstream.decode(String.self, forKey: .externalId)) ?? ""
        } else {
            self.externalId = ""
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(mobileNumber, forKey: .mobileNumber)
        try container.encode(locale, forKey: .locale)
        try container.encode(metadata, forKey: .metadata)
        try container.encode(organisations, forKey: .organisations)
        try container.encode(primaryOrganisationID, forKey: .primaryOrganisationID)
        try container.encode(avatarURL, forKey: .avatarURL)
        try container.encode(nonce, forKey: .nonce)
        try container.encode(paymentProvider, forKey: .paymentProvider)
        var upstream = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .upstream)
        try upstream.encode(externalId, forKey: .externalId)
    }

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case mobileNumber = "phone_number"
        case locale
        case metadata
        case organisations
        case primaryOrganisationID = "primary_organisation_id"
        case avatarURL = "avatar_url"
        case nonce
        case paymentProvider
        case upstream
        case externalId = "sub"
    }

    public static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.userId == rhs.userId
    }
}
