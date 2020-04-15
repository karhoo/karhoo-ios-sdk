//
//  SDKErrorFactory.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

class SDKErrorFactory {

    static func unexpectedError() -> KarhooError {
        return KarhooSDKError(code: "KSDK01", message: "Something went wrong but we don't know what it was")
    }

    static func getLoginPermissionError() -> KarhooError {
        return KarhooSDKError(code: "KSDK02", message: "Missing user permissions")
    }

    static func userAlreadyLoggedIn() -> KarhooError {
        return KarhooSDKError(code: "KSDK03", message: "User already logged in")
    }

    static func noConfigAvailableForView() -> KarhooError {
        return KarhooSDKError(code: "KSDK05", message: "There is no view config avialable for this view")
    }
}
