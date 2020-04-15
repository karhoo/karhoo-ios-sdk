//
//  MockPlaceSearchInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockPlaceSearchInteractor: PlaceSearchInteractor, MockInteractor {

    var callbackSet: CallbackClosure<Places>?
    var cancelCalled = false

    var placeSearchSet: PlaceSearch?
    func set(placeSearch: PlaceSearch) {
        self.placeSearchSet = placeSearch
    }
}
