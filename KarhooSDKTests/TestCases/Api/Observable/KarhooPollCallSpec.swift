//
//  KarhooPollCallSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooPollCallSpec: XCTestCase {

    private var testObject: PollCall<MockKarhooCodableModel>!
    private var mockPollExecutor: MockPollExecutor = MockPollExecutor()

    override func setUp() {
        super.setUp()

        testObject = PollCall<MockKarhooCodableModel>(pollExecutor: mockPollExecutor)
    }

    /**
     * When: getting multiple observables with the same pollTime
     * Then: should return the same observables
     */
    func testGetMultipleObservables() {
        let first = testObject.observable()
        let second = testObject.observable()
        let third = testObject.observable()

        XCTAssert(first === second)
        XCTAssert(first === third)
    }

    /**
     * When: getting multiple observables with the different pollTime
     * Then: should return different observables
     */
    func testGetMultipleObservablesWithDifferentPolltime() {
        let first = testObject.observable(pollTime: 5)
        let second = testObject.observable(pollTime: 5)
        let third = testObject.observable(pollTime: 10)

        XCTAssert(first === second)
        XCTAssertFalse(first === third)
    }
}
