//
//  LocationInfoExt.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public extension LocationInfo {

    func timezone() -> TimeZone {
        guard let defaultTimeZone = TimeZone(identifier: self.timeZoneIdentifier) else {
            return TimeZone.current
        }

        return defaultTimeZone
    }
}
