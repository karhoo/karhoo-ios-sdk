//
//  MockAvailabilityInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockAvailabilityInteractor: AvailabilityInteractor, MockInteractor {

    var callbackSet: CallbackClosure<Categories>?
    var cancelCalled = false

    var setAvailabilitySearch: AvailabilitySearch?
    func set(availabilitySearch: AvailabilitySearch) {
        setAvailabilitySearch = availabilitySearch
    }
}
