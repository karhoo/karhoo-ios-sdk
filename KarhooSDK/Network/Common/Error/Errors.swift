//
//  Errors.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

extension KarhooError {

    public func isConnectionError() -> Bool {
        guard let httpError = self as? HTTPError else { return false }
        return httpError.errorType == .connectionLost || httpError.errorType == .notConnectedToInternet
    }

    func isUnauthorizedError() -> Bool {
        var statusCode = 0
        if let sdkError = self as? KarhooSDKError {
            statusCode = sdkError.statusCode
        } else if let httpError = self as? HTTPError {
            statusCode = httpError.statusCode
        }
        return statusCode == 401
    }
}
