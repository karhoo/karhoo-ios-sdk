//
//  Item.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct Item: KarhooCodableModel {
    public let id: String
    public let name: String
    
    public init(id: String = "",
                name: String = "") {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
