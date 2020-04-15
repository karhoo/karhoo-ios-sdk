//
//  KarhooSDKConfiguration.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol KarhooSDKConfiguration {

    func environment() -> KarhooEnvironment

    func authenticationMethod() -> AuthenticationMethod

    func analyticsProvider() -> AnalyticsProvider
}

public extension KarhooSDKConfiguration {

    func analyticsProvider() -> AnalyticsProvider {
        return DefaultAnalyticsProvider()
    }
}
