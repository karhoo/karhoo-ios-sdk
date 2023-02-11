//
//  ReachabilityWrapperSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

import Reachability
@testable import KarhooSDK

class ReachabilityWrapperSpec: XCTestCase {

    private var mockReachability: MockReachability!
    private var mockBroadcaster: MockBroadcaster!
    private var testObject: ReachabilityWrapper!

    override func setUp() {
        super.setUp()

        mockReachability = MockReachability()
        mockBroadcaster = MockBroadcaster()

        testObject = ReachabilityWrapper(reachability: mockReachability,
                                         broadcaster: mockBroadcaster)
    }

    /**
     *  When:   Adding a listener
     *  Then:   The listener should be added to the underlying broadcaster
     *  And:    The listener should be informed of the current reachability status
     */
    func testAddListener() {
        let listener = TestReachabilityListener()
        mockReachability.reachabilityStatus = .cellular

        testObject.add(listener: listener)

        XCTAssert(mockBroadcaster.lastListenerAdded === listener)
        XCTAssert(listener.lastReachabilityStatus == true)
    }

    /**
     *  Given:  There are no listeners
     *   When:  Adding a listener
     *   Then:  Reachability notifier should be started
     */
    func testStartNotifier() {
        let listener = TestReachabilityListener()
        testObject.add(listener: listener)

        XCTAssertTrue(mockReachability.notifierRunning)
    }

    /**
     *  Given:  There's one reachability listener
     *   When:  A new listener is added
     *   Then:  Reachability notifier should keep running
     */
    func testNotifiersMultipleListeners() {
        let firstListener = TestReachabilityListener()
        let secondListener = TestReachabilityListener()

        testObject.add(listener: firstListener)
        testObject.add(listener: secondListener)

        XCTAssertTrue(mockReachability.notifierRunning)
    }

    /**
     *  Given: There is one reachability listener
     *  When: Last listener removed
     *  Then: Reachability notifier should be stopped
     */
    func testStopNotifier() {
        let listener = TestReachabilityListener()
        testObject.add(listener: listener)
        testObject.remove(listener: listener)

        XCTAssertFalse(mockReachability.notifierRunning)
    }

    /**
     *  When:   Removing a listener
     *  Then:   The listener should be removed from the underlying broadcaster
     */
    func testRemoveListener() {
        let listener = TestReachabilityListener()

        testObject.remove(listener: listener)

        XCTAssert(mockBroadcaster.lastListenerRemoved === listener)
    }

    /**
     *  When:   Checking if reachable
     *  Then:   The corresponding bool to each status should be returned
     */
    func testIsReachable() {
        let testCases: [Reachability.Connection: Bool] = [.unavailable: false,
                                                          .wifi: true,
                                                          .cellular: true]

        for (status, expectedResult) in testCases {
            mockReachability.reachabilityStatus = status
            let result = testObject.isReachable()

            XCTAssertEqual(result, expectedResult)
        }
    }

    /**
     *  When:   Reachability goes from reachable to non-reachable
     *  Then:   The listeners should be informed
     */
    func testReachabilityChangeReachableToNot() {
        changeReachability(to: .cellular)
        let listener = TestReachabilityListener()
        testObject.add(listener: listener)

        let listener2 = TestReachabilityListener()
        testObject.add(listener: listener2)

        changeReachability(to: .unavailable)

        XCTAssert(listener.lastReachabilityStatus == false)
        XCTAssert(listener2.lastReachabilityStatus == false)
    }

    /**
     *  When:   Reachability goes from unreachabble to reachabble
     *  Then:   The listeners should be informed
     */
    func testReachabilityChangeUnReachableToReachable() {
        let listener = TestReachabilityListener()
        testObject.add(listener: listener)

        let listener2 = TestReachabilityListener()
        testObject.add(listener: listener2)

        changeReachability(to: .wifi)

        XCTAssert(listener.lastReachabilityStatus == true)
        XCTAssert(listener2.lastReachabilityStatus == true)
    }

    /**
     *  When:   Reachability goes from reachable to reachable
     *  Then:   Nothing should happen (listeners should not be informed)
     */
    func testReachabilityChangeReachableToReachable() {
        changeReachability(to: .cellular)

        let listener = TestReachabilityListener()
        testObject.add(listener: listener)
        listener.lastReachabilityStatus = nil

        let listener2 = TestReachabilityListener()
        testObject.add(listener: listener2)
        listener2.lastReachabilityStatus = nil

        changeReachability(to: .wifi)

        XCTAssertNil(listener.lastReachabilityStatus)
        XCTAssertNil(listener2.lastReachabilityStatus)
    }

    /**
     *  When:   Reachability goes from unreachabble to unreachabble
     *  Then:   Nothing should happen (listeners should not be informed)
     */
    func testReachabilityChangeUnReachableToUnReachable() {
        changeReachability(to: .unavailable)

        let listener = TestReachabilityListener()
        testObject.add(listener: listener)
        listener.lastReachabilityStatus = nil

        let listener2 = TestReachabilityListener()
        testObject.add(listener: listener2)
        listener2.lastReachabilityStatus = nil

        changeReachability(to: .unavailable)

        XCTAssertNil(listener.lastReachabilityStatus)
        XCTAssertNil(listener2.lastReachabilityStatus)
    }

    private func changeReachability(to status: Reachability.Connection) {
        mockReachability.triggerReachabilityChange(to: status)

        let exp = expectation(description: "Waiting for callback")
        DispatchQueue.main.async {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }
}

private class MockReachability: ReachabilityProtocol {
    var reachabilityStatus: Reachability.Connection = .unavailable
    var whenReachable: Reachability.NetworkReachable?
    var whenUnreachable: Reachability.NetworkUnreachable?
    private(set) var notifierRunning = false

    var currentReachabilityStatus: Reachability.Connection {
        return reachabilityStatus
    }

    func triggerReachabilityChange(to status: Reachability.Connection) {
        reachabilityStatus = status
        let reachabilityObject = try? Reachability() /** this object is ignored, but is
         required as whenReachable/whenUnreachable callbacks parameter */

        if status == .unavailable {
            whenUnreachable?(reachabilityObject!)
        } else {
            whenReachable?(reachabilityObject!)
        }
    }

    func startNotifier() throws {
        notifierRunning = true
    }

    func stopNotifier() {
        notifierRunning = false
    }
}

private class TestReachabilityListener: ReachabilityListener {
     var lastReachabilityStatus: Bool?
     func reachabilityChanged(isReachable: Bool) {
        lastReachabilityStatus = isReachable
    }
}
