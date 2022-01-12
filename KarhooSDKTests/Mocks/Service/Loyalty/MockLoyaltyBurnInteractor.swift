//
//  MockLoyaltyBurnInteractor.swift
//  KarhooSDKTests
//
//  Created by Edward Wilkins on 18/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class MockLoyaltyBurnInteractor: LoyaltyBurnInteractor, MockInteractor {
    
    var callbackSet: CallbackClosure<LoyaltyPoints>?
    var cancelCalled = false
    
    var identifierSet: String?
    var currencySet: String?
    var amountSet: Int?
    func set(identifier: String, currency: String, amount: Int) {
        identifierSet = identifier
        currencySet = currency
        amountSet = amount
    }
}
