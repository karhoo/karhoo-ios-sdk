//
//  KarhooDriverTrackingService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooDriverTrackingService: DriverTrackingService {

    let trackDriverPollFactory: PollCallFactory
    init(trackDriverPollFactory: PollCallFactory = KarhooPollCallFactory()) {
        self.trackDriverPollFactory = trackDriverPollFactory
    }

    func trackDriver(tripId: String) -> PollCall<DriverTrackingInfo> {
        let interactor = KarhooDriverTrackingInteractor(tripId: tripId)
        return trackDriverPollFactory.shared(identifier: "trackDriver\(tripId)",
                                             executable: interactor)
    }
}
