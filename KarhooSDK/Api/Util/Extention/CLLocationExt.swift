//
//  CLLocationExt.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation

public extension CLLocation {
    func toPosition() -> Position {
        return Position(latitude: self.coordinate.latitude,
                        longitude: self.coordinate.longitude)
    }
}
