//
//  LogAnalyticsProviderSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

class LogAnalyticsProviderSpec: XCTestCase {

    private var testLogger: TestLogger!
    private var testObject: LogAnalyticsProvider!
    private let testEvent: String = AnalyticsConstants.EventNames.bookingRequested.description
    override func setUp() {
        super.setUp()

        testLogger = TestLogger()
        testObject = LogAnalyticsProvider(output: testLogger.log)
    }

    /**
     *  When:   Logging an event
     *  Then:   The corresponding string should be logged
     */
    func testLogEvent() {
        testObject.trackEvent(name: testEvent)

        XCTAssert(testLogger.stringToOutput.contains(testEvent))
    }

    /**
     *  When:   Logging an event with payload
     *  Then:   The corresponding string should be logged
     */
    func testLogEventWithPayload() {
        let testPayload = ["TestString": "abc", "TestInt": 2] as [String: Any]

        testObject.trackEvent(name: testEvent, payload: testPayload)

        XCTAssert(testLogger.stringToOutput.contains(testEvent.description))

        XCTAssert(testLogger.stringToOutput.contains("TestString"))
        XCTAssert(testLogger.stringToOutput.contains("abc"))

        XCTAssert(testLogger.stringToOutput.contains("TestInt"))
        XCTAssert(testLogger.stringToOutput.contains("2"))
    }

    /**
     *  When:   Logging an event with empty payload
     *  Then:   The corresponding string should be logged
     */
    func testLogEventWithEmptyPayload() {
        testObject.trackEvent(name: testEvent, payload: nil)

        XCTAssert(testLogger.stringToOutput.contains(testEvent.description))
    }
}

private class TestLogger {

    var stringToOutput: String = ""

    func log(string: String, args: CVarArg...) {
        stringToOutput += string
    }
}
