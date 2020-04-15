//
//  KarhooAnalyticsService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation

final class KarhooAnalyticsService: AnalyticsService {

    private let providers: [AnalyticsProvider]
    private let context: Context
    private let payloadBuilder: DefaultAnalyticsPayloadBuilder
    private let userDataStore: UserDataStore

    private let gdprSensitiveEvents: [AnalyticsConstants.EventNames] = [.appOpened]

    init(providers: [AnalyticsProvider]? = nil,
         payloadBuilder: DefaultAnalyticsPayloadBuilder = DefaultAnalyticsPayloadBuilder(),
         context: Context = CurrentContext(),
         userDataStore: UserDataStore = DefaultUserDataStore()) {
        if let providers = providers {
            self.providers = providers
        } else {
            self.providers = KarhooAnalyticsService.defaultProviders(context: context)
        }

        self.payloadBuilder = payloadBuilder
        self.context = context
        self.userDataStore = userDataStore
    }

    class func defaultProviders(context: Context) -> [AnalyticsProvider] {
        guard !context.isTestflightBuild() else {
            return [LogAnalyticsProvider()]
        }
        return [Karhoo.configuration.analyticsProvider()]
    }

    func send(eventName: AnalyticsConstants.EventNames) {
        if eventIsGdprSensitive(event: eventName) {
            return
        }

        send(eventName: eventName, payload: [:])
    }

    func send(eventName: AnalyticsConstants.EventNames, payload: [String: Any]) {
        if eventIsGdprSensitive(event: eventName) {
            return
        }

        var combinedPayload = getStandardPayload()
        payload.forEach { (key, value) in
            combinedPayload[key] = value }
        providers.forEach { $0.trackEvent(name: eventName.description, payload: combinedPayload) }
    }

    private func eventIsGdprSensitive(event: AnalyticsConstants.EventNames) -> Bool {
        return gdprSensitiveEvents.contains(event) && userDataStore.getCurrentUser() == nil
    }

    private func getStandardPayload() -> [String: Any] {
        return payloadBuilder.defaultPayload(context: CurrentContext())
    }
}
