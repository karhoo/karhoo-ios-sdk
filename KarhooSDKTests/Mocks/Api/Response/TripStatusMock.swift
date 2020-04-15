//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class TripStatusMock {
    private var tripStatus: TripStatus

    init() {
        self.tripStatus = TripStatus(status: .unknown)
    }

    func set(state: TripState) -> TripStatusMock {
        self.tripStatus = TripStatus(status: state)
        return self
    }

    func build() -> TripStatus {
        return tripStatus
    }

    func getTripStatus() -> TripStatus {
        return tripStatus
    }
}
