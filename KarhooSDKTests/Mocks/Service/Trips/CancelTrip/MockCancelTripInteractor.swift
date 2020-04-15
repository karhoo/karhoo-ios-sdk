//
//  MockCancelTripInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockCancelTripInteractor: CancelTripInteractor, MockInteractor {

    var callbackSet: CallbackClosure<KarhooVoid>?
    var cancelCalled = false

    var tripCancellationSet: TripCancellation?
    func set(tripCancellation: TripCancellation) {
        tripCancellationSet = tripCancellation
    }
}
