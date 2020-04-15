//
//  AnalyticsProviderProtocol.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol AnalyticsProvider {
    func trackEvent(name: String)
    func trackEvent(name: String, payload: [String: Any]?)
}

internal struct DefaultAnalyticsProvider: AnalyticsProvider {
    func trackEvent(name: String) {}
    func trackEvent(name: String, payload: [String: Any]?) {}
}
