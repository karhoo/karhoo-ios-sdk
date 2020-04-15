//
//  TimestampFormatterSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK

final class TimestampFormatterSpec: XCTestCase {

    private var testObject: TimestampFormatter!

    override func setUp() {
        super.setUp()

        testObject = TimestampFormatter()
    }

    /**
     *  When:   Formatting a date
     *  Then:   Result should be in a correct format
     */
    func testFormatDate() {
        let date = Date(timeIntervalSince1970: 0)
        let result = testObject.formattedDate(date)

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let expectedOutput = dateFormatter.string(from: date)

        XCTAssertEqual(expectedOutput, result)
    }
}
