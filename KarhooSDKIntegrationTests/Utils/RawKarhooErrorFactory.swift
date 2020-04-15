//
//  RawKarhooErrorFactory.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

struct RawKarhooErrorFactory {

    static func buildError(code: String) -> Data {
        return IntegrationTestError(code: code).encode()!
    }
}

private struct IntegrationTestError: KarhooError, KarhooCodableModel {

    let code: String
    let message: String

    init(code: String,
         message: String = "some") {
        self.code = code
        self.message = message
    }
}
