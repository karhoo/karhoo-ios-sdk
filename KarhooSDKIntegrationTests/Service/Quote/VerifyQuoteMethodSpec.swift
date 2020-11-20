//
//  VerifyQuoteMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  Created by Nurseda Balcioglu on 18/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooSDK

final class VerifyQuoteMethodSpec: XCTestCase {

    private let verifyQuotePath = "/v2/quotes/verify/quoteID"
    private var quoteService: QuoteService!
    private var call: Call<Quote>!

    override func setUp() {
        super.setUp()

        let verifyQuote = VerifyQuotePayload(quoteID: "quoteID")
        quoteService = Karhoo.getQuoteService()
        call = quoteService.verifyQuote(verifyQuotePayload: verifyQuote)
    }

    /**
      * Given: User is making a verify call
      * When: All requests succceed as expected
      * Then: Success result should be propogated
      */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "QuotesV2.json", path: verifyQuotePath)

        let expectation = self.expectation(description: "Calls callback with success result")
        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            XCTAssertEqual("1762fe84-cb53-11ea-994d-52087d195d90", result.successValue()?.id)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Searching for quotes
     * When: Verify Quote fails
     * Then: Expected error should be propogated
     */
    func testVerifyQuoteRequestErrorResponse() {
        NetworkStub.errorResponse(path: verifyQuotePath, responseData: RawKarhooErrorFactory.buildError(code: "K3003"))

        let expectation = self.expectation(description: "Calls callback with error result")
        call.execute(callback: { result in
            XCTAssertEqual(.couldNotFindSpecifiedQuote, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Searching for quotes
     * When: Quotes request times out
     * Then: Unknown error should be propogated
     */
    func testVerifyQuoteRequestTimeout() {
        NetworkStub.successResponse(jsonFile: "QuotesV2.json", path: verifyQuotePath)
        NetworkStub.errorResponseTimeOutConnection(path: verifyQuotePath)

        let expectation = self.expectation(description: "Calls callback with error result")
        call.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
}


