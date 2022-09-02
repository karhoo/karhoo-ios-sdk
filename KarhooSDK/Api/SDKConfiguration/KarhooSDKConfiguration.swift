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

    /// Closure to provide new auth token when the current one expires and there is no refresh token available
    var newTokenClosure: (() -> AuthToken)? { get }
}

public extension KarhooSDKConfiguration {

    func analyticsProvider() -> AnalyticsProvider {
        return DefaultAnalyticsProvider()
    }

    var newTokenClosure: (() -> AuthToken)? {
        {
            return AuthToken(accessToken: "debug-token")
        }
    }
}
