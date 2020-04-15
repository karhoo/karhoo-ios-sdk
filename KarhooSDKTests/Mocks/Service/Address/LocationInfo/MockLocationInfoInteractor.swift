//
//  MockLocationInfoInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockLocationInfoInteractor: LocationInfoInteractor, MockInteractor {

    var callbackSet: CallbackClosure<LocationInfo>?
    var cancelCalled = false

    var locationInfoSearchSet: LocationInfoSearch?
    func set(locationInfoSearch: LocationInfoSearch) {
        self.locationInfoSearchSet = locationInfoSearch
    }
}
