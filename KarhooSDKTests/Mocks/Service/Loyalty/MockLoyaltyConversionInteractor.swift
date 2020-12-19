//
//  MockLoyaltyConversionInteractor.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 18/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class MockLoyaltyConversionInteractor: LoyaltyConversionInteractor, MockInteractor {
    
    var callbackSet: CallbackClosure<LoyaltyConversion>?
    var cancelCalled = false
    
    var identifierSet: String?
    func set(identifier: String){
        identifierSet = identifier
    }
}
