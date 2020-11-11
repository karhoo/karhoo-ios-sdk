//
//  QuoteCoverage.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 10/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct QuoteCoverage: KarhooCodableModel {
    public var coverage: Bool

    public init(coverage: Bool = false) {
        self.coverage = coverage
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coverage = (try? container.decode(Bool.self, forKey: .coverage)) ?? false
    }
    
    enum CodingKeys: String, CodingKey {
        case coverage
    }
}
