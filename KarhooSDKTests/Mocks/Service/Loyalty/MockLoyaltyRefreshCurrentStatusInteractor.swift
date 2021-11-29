//
//  MockLoyaltyRefreshCurrentStatusInteractor.swift
//  KarhooSDKTests
//
//  Created by Diana Petrea on 29.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

import Foundation
@testable import KarhooSDK

final class MockLoyaltyRefreshCurrentStatusInteractor: RefreshCurrentLoyaltyStatusInteractor, MockInteractor {
    
    var callbackSet: CallbackClosure<LoyaltyStatus>?
    var cancelCalled = false
    
    var identifierSet: String?
    func set(identifier: String) {
        identifierSet = identifier
    }
}
