//
//  Payer.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Payer: KarhooCodableModel {

    public let id: String
    public let firstName: String
    public let lastName: String
    public let email: String

    public init(id: String = "",
                firstName: String = "",
                lastName: String = "",
                email: String = "") {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    public init(user: UserInfo) {
        self.init(id: user.userId,
                  firstName: user.firstName,
                  lastName: user.lastName,
                  email: user.email)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
}
