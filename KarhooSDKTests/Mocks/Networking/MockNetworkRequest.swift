//
//  MockNetworkRequest.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

final class MockNetworkRequest: NetworkRequest {

    private(set) var cancelCalled = false

    func cancel() {
        cancelCalled = true
    }
}
