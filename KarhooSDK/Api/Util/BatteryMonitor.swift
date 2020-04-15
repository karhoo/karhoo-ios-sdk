//
//  BatteryMonitor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import UIKit

final class BatteryMonitor {
    public var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
}
