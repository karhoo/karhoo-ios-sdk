//
//  LoyaltyProgramme.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct LoyaltyProgramme: KarhooCodableModel {
    
    public let id: String
    public let name: String
    
    public init(id: String = "",
                name: String = "") {
        self.id = id
        self.name = name
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = (try? container.decode(String.self, forKey: .id)) ?? ""
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
