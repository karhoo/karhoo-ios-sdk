//
//  UserUpdatePayload.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct UserDetailsUpdateRequest: KarhooCodableModel {
    
    public let firstName: String
    public let lastName: String
    public let phoneNumber: String
    public let locale: String?
    public let avatarURL: String?
    
    public init(firstName: String = "",
                lastName: String = "",
                phoneNumber: String = "",
                locale: String? = nil,
                avatarURL: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.locale = locale
        self.avatarURL = avatarURL
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case locale = "locale"
        case avatarURL = "avatar_url"
    }
}
