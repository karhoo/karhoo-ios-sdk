//
//  KarhooPollableExecutorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooPollableExecutorSpec: XCTestCase {

    private var testObject: KarhooPollExecutor!
    private var mockExecutable: MockExecutable<MockKarhooCodableModel>!
    private var mockTimingScheduler: MockTimingScheduler = MockTimingScheduler()

    override func setUp() {
        super.setUp()
        mockExecutable = MockExecutable<MockKarhooCodableModel>()
        testObject = PollExecutor(pollingScheduler: mockTimingScheduler,
                                      executable: mockExecutable)
    }

    /**
      * When: Starting polling
      * Then: pollingScheduler should fire in the set poll time repeating
      */
    func testStartPolling() {
        testObject.startPolling(pollTime: 5, callback: { (_: Result<MockKarhooCodableModel>) -> Void in})
        XCTAssertEqual(5, mockTimingScheduler.timeIntervalSet)
    }

    /**
      * When: Timing scheduler fires and executes callback
      * Then: Callback should be fired
      */
    func testTimingSchedulerFires() {
        var capturedResult: Result<MockKarhooCodableModel>?
        testObject.startPolling(pollTime: 5, callback: { (result: Result<MockKarhooCodableModel>) -> Void in
            capturedResult = result
        })

        mockTimingScheduler.fire()
        mockExecutable.triggerExecution(result: .success(result: MockKarhooCodableModel(id: "some")))

        XCTAssertEqual("some", capturedResult?.getSuccessValue()?.id)
    }

    /**
      * When: Stopping polling
      * Then: Polling schedulr should be invalidated
      * And: Excecutable should be cancelled
      */
    func testStopPolling() {
        testObject.stopPolling()

        XCTAssertTrue(mockTimingScheduler.invalidateCalled)
        XCTAssertTrue(mockExecutable.cancelCalled)
    }
}
