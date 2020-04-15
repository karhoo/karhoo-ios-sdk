//
//  IntegrationTestSetup.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooSDK

class IntegrationTestSetup: NSObject {

    override init() {
        Karhoo.set(configuration: MockSDKConfig())
    }
}
