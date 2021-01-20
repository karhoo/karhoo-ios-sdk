//
//  MockLoyaltyBalanceInteractor.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 17/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class MockLoyaltyBalanceInteractor: LoyaltyBalanceInteractor, MockInteractor {
    
    var callbackSet: CallbackClosure<LoyaltyBalance>?
    var cancelCalled = false
    
    var identifierSet: String?
    func set(identifier: String){
        identifierSet = identifier
    }
}
