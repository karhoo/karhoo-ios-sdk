//
//  KarhooError.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public protocol KarhooError: Error {
    var code: String { get }
    var message: String { get }
    var userMessage: String { get }
    var type: KarhooErrorType { get }
    var slug: String { get }
}

extension KarhooError {
    public var userMessage: String {
        message
    }

    // TODO: Temporary solution before all errors implement KarhooError
    public var code: String { "needs to be implemented" }
    public var message: String { "needs to be implemented" }
    public var slug: String { "needs to be implemented" }

    public func equals(_ error: KarhooError?) -> Bool {
        code == error?.code &&
            message == error?.message &&
            userMessage == error?.userMessage &&
            slug == error?.slug
    }

    public var type: KarhooErrorType {
        KarhooErrorType(error: self)
    }
}
