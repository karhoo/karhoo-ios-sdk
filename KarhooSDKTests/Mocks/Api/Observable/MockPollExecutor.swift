//
//  MockPollableExecutor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockPollExecutor: KarhooPollExecutor {
    private var callback: CallbackClosure<MockKarhooCodableModel>?

    var stopPollingCalled = false
    func stopPolling() {
        stopPollingCalled = true
    }

    var executable: KarhooExecutable {
        return MockExecutable<MockKarhooCodableModel>()
    }

    var startPollingCalled = false
    var pollingStartedWithTime: TimeInterval?
    func startPolling<T: KarhooCodableModel>(pollTime: TimeInterval, callback: @escaping CallbackClosure<T>) {
        self.pollingStartedWithTime = pollTime
        self.callback = callback as? (Result<MockKarhooCodableModel>) -> Void
        startPollingCalled = true
    }

    func trigger(result: Result<MockKarhooCodableModel>) {
        callback?(result)
    }
}
