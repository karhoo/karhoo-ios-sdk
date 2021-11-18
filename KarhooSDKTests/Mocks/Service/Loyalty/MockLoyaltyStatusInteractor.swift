//
//  MockLoyaltyStatusInteractor.swift
//  KarhooSDKTests
//
//  Created by Edward Wilkins on 18/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class MockLoyaltyStatusInteractor: LoyaltyStatusInteractor, MockInteractor {
    
    var callbackSet: CallbackClosure<LoyaltyStatus>?
    var cancelCalled = false
    
    var identifierSet: String?
    func set(identifier: String) {
        identifierSet = identifier
    }
}
