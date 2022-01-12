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
        return message
    }

    // TODO: Temporary solution before all errors implement KarhooError
    public var code: String { return "needs to be implemented" }
    public var message: String { return "needs to be implemented" }
    public var slug: String { return "needs to be implemented" }

    public func equals(_ error: KarhooError?) -> Bool {
        return self.code == error?.code &&
               self.message == error?.message &&
               self.userMessage == error?.userMessage &&
               self.slug == error?.slug
    }

    public var type: KarhooErrorType {
        return KarhooErrorType(error: self)
    }
}
