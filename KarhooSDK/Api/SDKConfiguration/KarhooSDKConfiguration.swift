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

    /// Closure to provide new auth credentials for KarhooSDK usage, when the current one expires and there is no refresh token available.
    func requestNewAuthenticationCredentials(callback: @escaping (Credentials?) -> Void)
}

public extension KarhooSDKConfiguration {

    func analyticsProvider() -> AnalyticsProvider {
        return DefaultAnalyticsProvider()
    }

    func requestNewAuthenticationCredentials(callback: @escaping (Credentials?) -> Void) {
        callback(nil)
    }
}
