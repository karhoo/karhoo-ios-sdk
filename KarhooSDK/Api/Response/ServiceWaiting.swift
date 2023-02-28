//
//  ServiceWaiting.swift
//  KarhooSDK
//
//  Created by Edward Wilkins on 17/02/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct ServiceWaiting: KarhooCodableModel {
    
    public let minutes: Int
    
    public init(minutes: Int = 0) {
        self.minutes = minutes
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.minutes = (try? container.decodeIfPresent(Int.self, forKey: .minutes)) ?? 0
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(minutes, forKey: .minutes)
    }
    
    enum CodingKeys: String, CodingKey {
        case minutes
    }
}
