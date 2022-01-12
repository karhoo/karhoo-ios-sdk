//
//  LoyaltyPreAuth.swift
//  KarhooSDK
//
//  Created by Edward Wilkins on 16/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct LoyaltyPreAuthPayload: KarhooCodableModel {
    
    public let currency: String
    public let points: Int
    public let flexpay: Bool
    public let membership: String
    
    public init(currency: String = "",
                points: Int = 0,
                flexpay: Bool = false,
                membership: String = "") {
        self.currency = currency
        self.points = points
        self.flexpay = flexpay
        self.membership = membership
    }
    
    enum CodingKeys: String, CodingKey {
        case currency
        case points
        case flexpay
        case membership = "loyalty_membership"
    }
}
