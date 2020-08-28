//
//  BatteryMonitor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

#if !os(macOS)
import UIKit
#endif

final class BatteryMonitor {
    public var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
}
