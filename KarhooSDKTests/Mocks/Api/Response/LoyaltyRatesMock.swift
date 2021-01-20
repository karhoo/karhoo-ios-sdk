//
//  LoyaltyRatesMock.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 18/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooSDK

class LoyaltyRatesMock {

    private var loyaltyRates: LoyaltyRates

    init() {
        self.loyaltyRates = LoyaltyRates(currency: "", points: "")
    }

    func set(currency: String, points: String) -> LoyaltyRatesMock {
        self.loyaltyRates = LoyaltyRates(currency: currency,
                                         points: points)
        return self
    }
    
    func create(currency: String? = nil,
                points: String? = nil) {
        loyaltyRates = LoyaltyRates(currency: currency ?? loyaltyRates.currency,
                                    points: points ?? loyaltyRates.points)
    }

    func build() -> LoyaltyRates {
        return loyaltyRates
    }
}
