//
//  KarhooTokenRefreshNeedWorker.swift
//  KarhooSDK
//
//  Created by Aleksander Wedrychowski on 05/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol TokenValidityWorker: AnyObject {
    /// Return a value when a new refresh token should be requested
    func timeToRequiredRefresh() -> TimeInterval
    func saveRefreshBuffer(token: AuthToken)
    func tokenNeedsRefreshing() -> Bool
    func refreshTokenNeedsRefreshing() -> Bool
}

final class KarhooTokenValidityWorker: TokenValidityWorker {
    
    // MARK: - Nested types
    
    private enum Constants {
        /// Seconds buffer when refresh token should be refreshed proactively, so it never becomes expired. Updated each time new AuthToken is saved.
        static var refreshBuffer: TimeInterval?
        static let refreshBufferModifierBar: TimeInterval = 60
        static let refreshBufferMinPercentageModifier: Double = 0.05
        static let refreshBufferMaxPercentageModifier: Double = 0.20
        static let minimalTimeToRequiredRefresh: TimeInterval = 30
    }
    
    // MARK: - Properties
    
    private let dataStore: UserDataStore
    
    // MARK: - Lifecycle
    
    init(dataStore: UserDataStore = DefaultUserDataStore()) {
        self.dataStore = dataStore
    }
    
    // MARK: - Endpoints
    
    func timeToRequiredRefresh() -> TimeInterval {
        guard let credentials = dataStore.getCurrentCredentials() else {
            assertionFailure("Credentials should be set at this stage")
            return Constants.minimalTimeToRequiredRefresh
        }

        guard let refreshBuffer = Constants.refreshBuffer else {
            calculateRefreshBufferIfNeeded()
            return timeToRequiredRefresh()
        }
        
        let timeToRefresh: TimeInterval = max(
            Constants.minimalTimeToRequiredRefresh,
            (credentials.expiryDate?.timeIntervalSinceNow ?? 0) - refreshBuffer
        )
        return timeToRefresh
    }
    
    func saveRefreshBuffer(token: AuthToken) {
        setRefreshBuffer(timeToRefresh: TimeInterval(token.expiresIn))
    }
    
    func tokenNeedsRefreshing() -> Bool {
        guard let credentials = dataStore.getCurrentCredentials() else {
            return false
        }
        return checkDateDueTime(for: credentials.expiryDate)
    }
    
    func refreshTokenNeedsRefreshing() -> Bool {
        guard let credentials = dataStore.getCurrentCredentials() else {
            return false
        }
        return checkDateDueTime(for: credentials.refreshTokenExpiryDate)
    }
    
    // Check if expire date for refresh token or token makes it needs to be renewed
    private func checkDateDueTime(for date: Date?) -> Bool {
        guard let date = date else {
            return true
        }

        guard let refreshBuffer = Constants.refreshBuffer else {
            calculateRefreshBufferIfNeeded()
            return checkDateDueTime(for: date)
        }

        let timeToExpiration = date.timeIntervalSince1970 - Date().timeIntervalSince1970
        return timeToExpiration < refreshBuffer
    }

    /// If the buffer has not been set during the app lifecycle, calculate the value accordingly.
    private func calculateRefreshBufferIfNeeded() {
        guard let credentials = dataStore.getCurrentCredentials() else {
            return
        }
        setRefreshBuffer(timeToRefresh: credentials.expiryDate?.timeIntervalSinceNow ?? 0)
    }
    
    private func setRefreshBuffer(timeToRefresh: TimeInterval) {
        let isTimeShorterThanMinimal = timeToRefresh < Constants.refreshBufferModifierBar
        let modifier = isTimeShorterThanMinimal ? Constants.refreshBufferMaxPercentageModifier : Constants.refreshBufferMinPercentageModifier
        let calculatedRefreshBuffer = timeToRefresh * modifier
        Constants.refreshBuffer = calculatedRefreshBuffer
    }
}
