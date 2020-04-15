//
//  TestContext.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockContext: Context {
    var isTestflightBuildReturnValue = false

    func getSdkBundle() -> Bundle {
        return Bundle.main
    }

    func getCurrentBundle() -> Bundle {
        return Bundle.main
    }

    func isTestflightBuild() -> Bool {
        return isTestflightBuildReturnValue
    }
}
