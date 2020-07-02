//
//  AnalyticsPayloadBuilder.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation

final class DefaultAnalyticsPayloadBuilder {

    private var payload = [String: Any]()
    private let timestampFormatter = TimestampFormatter()
    private let uuidProvider = DeviceIdentifierProvider.shared
    private let locationProvider: UserLocationProvider
    private let batteryMonitor: BatteryMonitor
    private let networkTypeProvider = NetworkConnectionTypeProvider()

    init(locationProvider: UserLocationProvider = KarhooUserLocationProvider(),
         batteryMonitor: BatteryMonitor = BatteryMonitor()) {
        self.locationProvider = locationProvider
        self.batteryMonitor = batteryMonitor
    }

    func defaultPayload(context: Context = CurrentContext()) -> [String: Any] {
        payload = [:]
        addBundleId(context: context)
        addUserPayload()
        addTimestamp()
        addSessionIDs()
        addBatteryLevel()
        addNetworkType()
        addAppVersion()
        return payload
    }

    private func addBundleId(context: Context) {
        let unknownBundleId = AnalyticsConstants.Keys.unkownBundleIdentifier.description
        let bundleId = context.getCurrentBundle().bundleIdentifier ?? unknownBundleId
        payload[AnalyticsConstants.Keys.sendingApp.description] = bundleId
    }

    private func addUserPayload() {
        let authState = Karhoo.configuration.authenticationMethod()
        payload[AnalyticsConstants.EventNames.guestMode.description] = authState.isGuest()
        addUserLocationPayload(location: locationProvider.getLastKnownLocation())

        guard let user = KarhooUserService().getCurrentUser() else {
            return
        }

        payload[AnalyticsConstants.Keys.userId.description] = user.userId
    }

    private func addUserLocationPayload(location: CLLocation?) {
        guard let location = location else {
            return
        }

        payload[AnalyticsConstants.Keys.locationAccuracy.description] = location.horizontalAccuracy
        payload[AnalyticsConstants.Keys.locationLat.description] = location.coordinate.latitude
        payload[AnalyticsConstants.Keys.locationLong.description] = location.coordinate.longitude
    }

    private func addSessionIDs() {
        payload[AnalyticsConstants.Keys.sessionID.description] = uuidProvider.getSessionID()
        payload[AnalyticsConstants.Keys.permID.description] = uuidProvider.getPermamentID()
    }

    private func addTimestamp() {
        payload[AnalyticsConstants.Keys.timestamp.description] = timestampFormatter.formattedDate(Date())
    }

    private func addBatteryLevel() {
        payload[AnalyticsConstants.Keys.batteryLife.description] = batteryMonitor.batteryLevel
    }

    private func addNetworkType() {
        payload[AnalyticsConstants.Keys.networkType.description] = networkTypeProvider.connectionType()
    }

    private func addAppVersion() {
        payload[AnalyticsConstants.Keys.appVersion.description] = appVersion()
    }

    private func appVersion() -> String {
        guard let info = Bundle.main.infoDictionary else {
            return ""
        }

        let build = info["CFBundleVersion"] as? String
        let version = info["CFBundleShortVersionString"] as? String

        return "\(version ?? "") (\(build ?? ""))"
    }
}
