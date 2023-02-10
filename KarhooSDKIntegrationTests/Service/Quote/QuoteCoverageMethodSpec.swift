//
//  QuoteCoverageMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  Created by Nurseda Balcioglu on 11/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class QuoteCoverageMethodSpec: XCTestCase {

    private let quoteCoveragePath = "/v2/quotes/coverage"
    private var quoteService: QuoteService!
    private var call: Call<QuoteCoverage>!

    override func setUp() {
        super.setUp()

        let quoteCoverage = QuoteCoverageRequest(latitude: "", longitude: "", localTimeOfPickup: "")
        quoteService = Karhoo.getQuoteService()
        call = quoteService.coverage(coverageRequest: quoteCoverage)
    }

    /**
      * Given: User is making a coverage call
      * When: All requests succceed as expected
      * Then: Success result should be propogated
      */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "QuoteCoverage.json", path: quoteCoveragePath)

        let expectation = self.expectation(description: "Calls callback with success result")
        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())

            XCTAssertEqual(true, result.successValue()?.coverage)

            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Searching for quotes
     * When: QuoteCoverage fails
     * Then: Expected error should be propogated
     */
    func testQuoteCoverageRequestErrorResponse() {
        NetworkStub.errorResponse(path: quoteCoveragePath, responseData: RawKarhooErrorFactory.buildError(code: "KSDK01"))

        let expectation = self.expectation(description: "Calls callback with error result")
        call.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Searching for quotes
     * When: Quotes request times out
     * Then: Unknown error should be propogated
     */
    func testQuotesRequestTimeout() {
        NetworkStub.successResponse(jsonFile: "QuoteCoverage.json", path: quoteCoveragePath)
        NetworkStub.errorResponseTimeOutConnection(path: quoteCoveragePath)

        let expectation = self.expectation(description: "Calls callback with error result")
        call.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }
}

