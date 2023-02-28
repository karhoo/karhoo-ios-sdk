//
//  Organisation.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Organisation: KarhooCodableModel {

    public let id: String
    public let name: String
    public let roles: [String]

    internal init(id: String = "",
                  name: String = "",
                  roles: [String] = []) {
        self.id = id
        self.name = name
        self.roles = roles
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decodeIfPresent(String.self, forKey: .id)) ?? ""
        self.name = (try? container.decodeIfPresent(String.self, forKey: .name)) ?? ""
        self.roles = (try? container.decodeIfPresent([String].self, forKey: .roles)) ?? []
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(roles, forKey: .roles)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case roles
    }
}
