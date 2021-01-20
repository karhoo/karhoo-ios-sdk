//
//  CancelledByPayer.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 08/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct CancelledByPayer: KarhooCodableModel {
    
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

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(String.self, forKey: .id)) ?? ""
        self.firstName = (try? container.decode(String.self, forKey: .firstName)) ?? ""
        self.lastName = (try? container.decode(String.self, forKey: .lastName)) ?? ""
        self.email = (try? container.decode(String.self, forKey: .email)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
    }
}
