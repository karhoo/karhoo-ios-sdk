//
//  KarhooObservableSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooObservableSpec: XCTestCase {

    private var testObject: Observable<MockKarhooCodableModel>!
    private var mockPollExecutor = MockPollExecutor()
    private var mockObserverBroadcaster = MockObserverBroadcaster<MockKarhooCodableModel>()

    override func setUp() {
        super.setUp()

        testObject = Observable<MockKarhooCodableModel>(pollExecutor: mockPollExecutor,
                                                              pollTime: 1.5,
                                                              broadcaster: mockObserverBroadcaster)
    }

    /**
      * When: Calling observe for the first time
      * Then: Observable should add passed callbackclosure to the closure broadcaster
      * And:  Observable should tell its pollable executor to start polling
      */
    func testFirstObserve() {
        let observer = Observer<MockKarhooCodableModel> { _ in }
        testObject.subscribe(observer: observer)
        XCTAssertTrue(mockPollExecutor.startPollingCalled)
        XCTAssertTrue(mockObserverBroadcaster.addListenerCalled)
    }

    /**
     * When: Calling observe for the second time
     * Then: Observable should add passed callbackclosure to the closure broadcaster
     * And:  Observable should tell its pollable executor to start polling only once
     */
    func testSecondObserve() {
        let firstObserver = Observer<MockKarhooCodableModel> { _ in }
        testObject.subscribe(observer: firstObserver)
        XCTAssertTrue(mockPollExecutor.startPollingCalled)

        mockPollExecutor.startPollingCalled = false
        let secondObserver = Observer<MockKarhooCodableModel> { _ in }
        testObject.subscribe(observer: secondObserver)
        XCTAssertFalse(mockPollExecutor.startPollingCalled)

        XCTAssertTrue(mockObserverBroadcaster.addListenerCalled)
    }

    /**
      * When: Pollable executor returns with a result
      * Then: Broadcaster should broadcast result
      */
    func testObservablePollReturnsResult() {
        var observeResult: Result<MockKarhooCodableModel>?
        let observer = Observer<MockKarhooCodableModel> { result in
            observeResult = result
        }
        testObject.subscribe(observer: observer)

        mockPollExecutor.trigger(result: .success(result: MockKarhooCodableModel(id: "some")))

        XCTAssertEqual("some", mockObserverBroadcaster.broadcastedResult?.successValue()?.id)
        XCTAssertEqual("some", observeResult?.successValue()?.id)
    }

}
