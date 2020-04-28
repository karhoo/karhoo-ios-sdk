//
//  MockAnalyticsService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockAnalyticsService: AnalyticsService {

    var eventSent: AnalyticsConstants.EventNames?
    var payloadSent: [String: Any]?
    
    func send(eventName: AnalyticsConstants.EventNames, payload: [String: Any]) {
        eventSent = eventName
        payloadSent = payload
    }

    func send(eventName: AnalyticsConstants.EventNames) {
        eventSent = eventName
    }
}
