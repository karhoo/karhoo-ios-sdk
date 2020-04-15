//
//  DriverTrackingService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol DriverTrackingService {
    func trackDriver(tripId: String) -> PollCall<DriverTrackingInfo>
}
