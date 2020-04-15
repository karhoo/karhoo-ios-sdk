//
//  MockTripStatusInteractor.swift
//  KarhooSDKTests
// 
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockTripStatusInteractor: TripStatusInteractor, MockInteractor {

    var callbackSet: CallbackClosure<TripState>?
    var cancelCalled = false
}
