//
//  KarhooNetworkDateFormatterSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class KarhooNetworkDateFormatterSpec: XCTestCase {

    /**
     *  Given:   Requesting availability (quotes)
     *  When:    Date is UTC
     *  Then:    The string should be correct in the correct (iso-8601) format (no seconds)
     */
    func testConvertingDateForAvailabilityRequestUTC() {
        let date = Date(timeIntervalSince1970: 150000)
        let output = KarhooNetworkDateFormatter(formatType: .availability).toString(from: date)

        XCTAssertEqual("1970-01-02T17:40", output)
    }

    /**
     *  Given:   Requesting availability (quotes)
     *  When:    Time zone is CET (Paris)
     *  Then:    The string should be correct in the correct (iso-8601) format (no seconds)
     */
    func testConvertingDateForAvailabilityRequestInParis() {
        let dateRequired = Date(timeIntervalSince1970: 1494583933) // UTC (2017-05-12T10:12)

        let dateFormatter = KarhooNetworkDateFormatter(timeZone: TimeZone(abbreviation: "CET")!,
                                                       formatType: .availability)
        let output = dateFormatter.toString(from: dateRequired)

        XCTAssertEqual("2017-05-12T12:12", output)
    }

    /**
      * Given: date_scheduled API response as input (returned in UTC)
      * When: Time zone in UTC
      * Then: expected Date should be set
      * And: the expected date should be represented correctly as a string
      */
    func testDateScheduledUTC() {
        let input = "2018-04-21T12:35:00Z"
        let dateFormatter = KarhooNetworkDateFormatter(formatType: .booking)
        let output = dateFormatter.toDate(from: input)
        XCTAssertEqual("2018-04-21 12:35:00 +0000", output?.description)
    }

    /**
     * Given: date_scheduled API response as input (returned in UTC)
     * When: Time zone is CET
     * Then: expected Date should be set
     * And: the expected date should be represented correctly as a string
     */
    func testDateScheduledParis() {
        let input = "2018-04-21T12:35:00Z"
        let stringToDateFormatter = KarhooNetworkDateFormatter(formatType: .booking)
        let dateOutput = stringToDateFormatter.toDate(from: input)

        XCTAssertEqual("2018-04-21 12:35:00 +0000", dateOutput?.description)

        let dateToStringFormatter = KarhooNetworkDateFormatter(timeZone: TimeZone(abbreviation: "CET"),
                                                               formatType: .booking)
        let formatterOutput = dateToStringFormatter.toString(from: dateOutput!)
        XCTAssertEqual("2018-04-21T14:35:00GMT+2", formatterOutput)
    }
}
