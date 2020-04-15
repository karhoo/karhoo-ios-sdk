//
//  MockTripSearchInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockTripSearchInteractor: TripSearchInteractor, MockInteractor {

    var callbackSet: CallbackClosure<[TripInfo]>?
    var cancelCalled = false

    var tripSearchSet: TripSearch?
    func set(tripSearch: TripSearch) {
        tripSearchSet = tripSearch
    }
}
