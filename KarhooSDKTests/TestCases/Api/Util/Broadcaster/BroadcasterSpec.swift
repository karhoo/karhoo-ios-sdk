//
//  BroadcasterSpec.swift
//  YMBroadcaster
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

class BroadcasterSpec: XCTestCase {

    /**
     *  When    Adding a listener
     *  Then    The listener should be notified of the changes
     */
    func testAddListener() {
        let broadcaster = Broadcaster<Listener>()
        let listener = Listener()
        broadcaster.add(listener: listener)

        broadcaster.broadcast { (listenerToInvoke) in
            XCTAssert(listener === listenerToInvoke)
        }
    }

    /**
     *  When    Removing a listener
     *  Then    The listener should no longer be notified of the changes
     */
    func testRemoveListener() {
        let broadcaster = Broadcaster<Listener>()
        let listener = Listener()
        broadcaster.add(listener: listener)
        broadcaster.remove(listener: listener)

        broadcaster.broadcast { (_) in
            XCTAssert(false)
        }
    }

    /**
     *  When    Removing a listener which was never added
     *  Then    Nothing should happen
     */
    func testRemoveNonExistantListener() {
        let broadcaster = Broadcaster<Listener>()
        let listener = Listener()
        broadcaster.remove(listener: listener)
    }

    /**
     *  When    Broadcasting a message
     *  Then    All the listeners should be notified
     */
    func testBroadcast() {
        let broadcaster = Broadcaster<Listener>()
        let listener1 = Listener()
        let listener2 = Listener()
        let listener3 = Listener()
        let listeners = [listener1, listener2, listener3]

        broadcaster.add(listener: listener1)
        broadcaster.add(listener: listener2)
        broadcaster.add(listener: listener3)

        broadcaster.broadcast { (listenerToInvoke) in
            XCTAssert(listeners.contains(where: { (listener: Listener) -> Bool in
                return listener === listenerToInvoke
            }))
        }
    }

    /**
     *  When    A listener responds to a broadcast by removing itself
     *  Then    All the listeners should be notified
     *   And    The listener should be removed
     */
    func testBroadcastWhileRemovingListener() {
        let broadcaster = Broadcaster<Listener>()
        let listener1 = Listener()
        let listener2 = Listener()
        let listener3 = Listener()

        broadcaster.add(listener: listener1)
        broadcaster.add(listener: listener2)
        broadcaster.add(listener: listener3)

        broadcaster.broadcast { (listenerToInvoke) in
            if listenerToInvoke === listener2 {
                broadcaster.remove(listener: listener2)
            }
        }

        broadcaster.broadcast { (listenerToInvoke) in
            XCTAssert(listenerToInvoke !== listener2)
        }
    }

    /**
     *  When    A listener is deallocated without being removed
     *  Then    The broadcast should still work
     *   And    The listener should be removed
     */
    func testListenerDeallocated() {
        let broadcaster = Broadcaster<Listener>()
        let listener1 = Listener()
        var listener2: Listener? = Listener()
        let listener3 = Listener()

        broadcaster.add(listener: listener1)
        broadcaster.add(listener: listener2!)
        broadcaster.add(listener: listener3)

        let deinitExpectation = expectation(description: "Listener deallocated")
        listener2?.deinitCallback = {
            deinitExpectation.fulfill()
        }
        listener2 = nil

        broadcaster.broadcast { (listenerToInvoke) in
            XCTAssert(listenerToInvoke !== listener2)
        }

        waitForExpectations(timeout: 10, handler: nil)

    }
}

class Listener {
    var deinitCallback: (() -> Void)?

    deinit {
        deinitCallback?()
    }
}
