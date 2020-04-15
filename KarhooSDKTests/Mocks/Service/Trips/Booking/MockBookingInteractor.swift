//
//  TestBookingInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockBookingInteractor: BookingInteractor, MockInteractor {

    var callbackSet: CallbackClosure<TripInfo>?
    var cancelCalled = false

    var tripBookingSet: TripBooking?
    func set(tripBooking: TripBooking) {
        tripBookingSet = tripBooking
    }
}
