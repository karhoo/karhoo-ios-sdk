//
//  MockTripUpdateInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockTripUpdateInteractor: TripUpdateInteractor, MockInteractor {

    var callbackSet: CallbackClosure<TripInfo>?
    var cancelCalled = false
}
