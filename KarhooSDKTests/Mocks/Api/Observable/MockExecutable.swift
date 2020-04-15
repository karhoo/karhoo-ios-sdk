//
//  TestKarhooCall.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

class MockExecutable<T: KarhooCodableModel>: KarhooExecutable {

    private var callback: CallbackClosure<MockKarhooCodableModel>?

    var didExecute = false
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        self.callback = callback as? (Result<MockKarhooCodableModel>) -> Void
        didExecute = true
    }

    var cancelCalled = false
    func cancel() {
        cancelCalled = true
    }

    func triggerExecution(result: Result<MockKarhooCodableModel>) {
        callback?(result)
    }
}
