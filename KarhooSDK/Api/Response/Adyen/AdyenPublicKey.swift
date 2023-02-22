//
//  AdyenPublicKey.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 14/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPublicKey: KarhooCodableModel {
    
    public let key: String
    
    public init(key: String = "") {
        self.key = key
    }
    
    enum CodingKeys: String, CodingKey {
        case key
    }
    
    public init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          self.key = (try? container.decodeIfPresent(String.self, forKey: .key)) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
    }
    
}
