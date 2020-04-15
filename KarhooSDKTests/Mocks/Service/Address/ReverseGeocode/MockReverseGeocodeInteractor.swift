//
//  MockReverseGeocodeInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockReverseGeocodeInteractor: ReverseGeocodeInteractor, MockInteractor {

    var callbackSet: CallbackClosure<LocationInfo>?
    var cancelCalled = false

    var positionSet: Position?
    func set(position: Position) {
        self.positionSet = position
    }
}
