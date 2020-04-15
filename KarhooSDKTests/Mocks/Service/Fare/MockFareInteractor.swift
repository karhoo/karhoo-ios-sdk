//
//  MockFareInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockFareInteractor: FareInteractor, MockInteractor {
    var callbackSet: CallbackClosure<Fare>?
    var cancelCalled = false
    var tripIdSet: String?
    
    func set(tripId: String) {
        self.tripIdSet = tripId
    }
}
