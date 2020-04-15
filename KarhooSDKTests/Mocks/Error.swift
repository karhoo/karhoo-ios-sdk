//
//  Errors.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooSDK

struct MockError: KarhooError, Equatable {
    var code: String
    var message: String
    var userMessage: String

    static func == (lhs: MockError, rhs: MockError) -> Bool {
        return lhs.code == rhs.code
            && lhs.message == rhs.message
            && lhs.userMessage == rhs.userMessage
    }
}
