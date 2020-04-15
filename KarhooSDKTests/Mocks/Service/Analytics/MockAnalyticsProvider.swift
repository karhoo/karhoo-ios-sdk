//
//  MockAnalyticsProvider.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockAnalyticsProvider: AnalyticsProvider {

    var trackedName: String?
    var trackedProperties: [String: Any]?

    func trackEvent(name: String) {
        trackedName = name
    }

    func trackEvent(name: String, payload: [String: Any]?) {
                trackedName = name
        trackedProperties = payload
    }
}
