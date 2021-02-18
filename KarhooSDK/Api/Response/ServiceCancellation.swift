//
//  ServiceCancellation.swift
//  KarhooSDK
//
//  Created by Edward Wilkins on 17/02/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct ServiceCancellation: KarhooCodableModel {
    
    public let type: String
    public let minutes: Int
    
    public init(type: String = "",
                minutes: Int = 0) {
        self.type = type
        self.minutes = minutes
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
        self.minutes = (try? container.decode(Int.self, forKey: .minutes)) ?? 0
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(minutes, forKey: .minutes)
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case minutes
    }
}
