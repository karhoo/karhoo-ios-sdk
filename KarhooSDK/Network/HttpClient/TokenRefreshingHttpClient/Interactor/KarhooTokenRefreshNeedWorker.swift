//
//  KarhooTokenRefreshNeedWorker.swift
//  KarhooSDK
//
//  Created by Aleksander Wedrychowski on 05/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol TokenRefreshNeedWorker: AnyObject {
    func saveRefreshBuffer(token: AuthToken)
    func tokenNeedsRefreshing(credentials: Credentials) -> Bool
    func refreshTokenNeedsRefreshing(credentials: Credentials?) -> Bool
}

final class KarhooTokenRefreshNeedWorker: TokenRefreshNeedWorker {
    private enum Constants {
        /// Seconds buffer when refresh token should be refreshed proactively, so it never becomes expired. Default value 5 mins. Updated each time new AuthToken is saved.
        static var refreshBuffer: TimeInterval = 5 * 60
        static let refreshBufferMinimalTimeInterval: TimeInterval = 60
        static let refreshBufferMinPercentageModifier: Double = 0.05
        static let refreshBufferMaxPercentageModifier: Double = 0.20
    }
    
    func saveRefreshBuffer(token: AuthToken) {
        let isTimeShorterThanMinimal = Double(token.expiresIn) < Constants.refreshBufferMinimalTimeInterval
        let modifier = isTimeShorterThanMinimal ? Constants.refreshBufferMaxPercentageModifier : Constants.refreshBufferMinPercentageModifier
        let calculatedRefreshBuffer = Double(token.expiresIn) * modifier
        Constants.refreshBuffer = calculatedRefreshBuffer
    }

    func tokenNeedsRefreshing(credentials: Credentials) -> Bool {
        checkDateDueTime(for: credentials.expiryDate)
    }
    
    func refreshTokenNeedsRefreshing(credentials: Credentials?) -> Bool {
        guard let credentials = credentials else {
            return true
        }
        return checkDateDueTime(for: credentials.refreshTokenExpiryDate)
    }
    
    // Check if expire date for refresh token or token makes it needs to be renewed
    private func checkDateDueTime(for date: Date?) -> Bool {
        guard let date = date else {
            return true
        }
        let timeToExpiration = date.timeIntervalSince1970 - Date().timeIntervalSince1970
        return timeToExpiration < Constants.refreshBuffer
    }
}
