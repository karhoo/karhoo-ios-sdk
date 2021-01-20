//
//  Agent.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 08/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct Agent: KarhooCodableModel {
    
    public let userID: String
    public let userName: String
    public let orgID: String
    public let orgName: String

    public init(userID: String = "",
                userName: String = "",
                orgID: String = "",
                orgName: String = "") {
        self.userID = userID
        self.userName = userName
        self.orgID = orgID
        self.orgName = orgName
    }

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case orgID = "organisation_id"
        case orgName = "organisation_name"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = (try? container.decode(String.self, forKey: .userID)) ?? ""
        self.userName = (try? container.decode(String.self, forKey: .userName)) ?? ""
        self.orgID = (try? container.decode(String.self, forKey: .orgID)) ?? ""
        self.orgName = (try? container.decode(String.self, forKey: .orgName)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userID, forKey: .userID)
        try container.encode(userName, forKey: .userName)
        try container.encode(orgID, forKey: .orgID)
        try container.encode(orgName, forKey: .orgName)
    }
}
