//
//  MockPreAuthInteractor.swift
//  KarhooSDKTests
//
//  Created by Edward Wilkins on 18/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class MockLoyaltyPreAuthInteractor: LoyaltyPreAuthInteractor, MockInteractor {
    
    var callbackSet: CallbackClosure<LoyaltyPreAuthPayload>?
    var cancelCalled = false
    
    var identifierSet: String?
    func set(identifier: String) {
        identifierSet = identifier
    }
}
