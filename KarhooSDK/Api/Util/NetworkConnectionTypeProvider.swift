//
//  NetworkConnectionTypeProvider.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreTelephony

final class NetworkConnectionTypeProvider {
    func connectionType() -> String {
        let status = ReachabilityWrapper.shared.currentReachabilityStatus
        var networkType = status.description

        if status == .cellular {
            networkType = coreTelephonyNetworkStatus()
        }
        return networkType
    }

    private func coreTelephonyNetworkStatus() -> String {
        let networkString = CTTelephonyNetworkInfo().currentRadioAccessTechnology ?? ""

        switch networkString {
        case CTRadioAccessTechnologyLTE:
            return "4G"
        case CTRadioAccessTechnologyGPRS,
             CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyCDMA1x:
            return "2G"
        case CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD:
            return "3G"
        default:
            return ""
        }
    }
}
