//
//  UnitTestSetup.swift
//  KarhooSDKTests
//
//  
//  Copyright @ 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class UnitTestSetup: NSObject {

    override init() {
        Karhoo.set(configuration: MockSDKConfig())
    }
}
