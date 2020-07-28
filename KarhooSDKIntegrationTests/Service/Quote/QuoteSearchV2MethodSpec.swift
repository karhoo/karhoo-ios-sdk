//
//  QuoteSearchV2MethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class QuoteSearchV2MethodSpec: XCTestCase {

    private let quoteListIdPath = "/v2/quotes"
    private let quotesPath = "/v2/quotes/some-id"
    private var quoteService: QuoteService!
    private var pollCall: PollCall<Quotes>!

    override func setUp() {
        super.setUp()

        let quoteSearch = QuoteSearch(origin: LocationInfoMock().set(placeId: "originPlaceId").build(),
                                      destination: LocationInfoMock().set(placeId: "destinationPlaceId").build(),
                                      dateScheduled: Date())
        quoteService = Karhoo.getQuoteService()
        pollCall = quoteService.quotesV2(quoteSearch: quoteSearch)
    }

    /**
      * Given: Searching for quotes
      * When: All requests succceed as expected
      * Then: Success result should be propogated
      */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "QuoteListId.json", path: quoteListIdPath)
        NetworkStub.successResponse(jsonFile: "QuotesV2.json", path: quotesPath)

        let expectation = self.expectation(description: "Calls callback with success result")
        pollCall.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            self.assertSuccess(quote: result.successValue()?.all[0])

            XCTAssertEqual(6, result.successValue()?.quoteCategories.count)
            XCTAssertEqual(1, result.successValue()?.quotes(for: "Saloon").count)
            XCTAssertEqual(0, result.successValue()?.quotes(for: "Taxi").count)
            XCTAssertEqual(0, result.successValue()?.quotes(for: "MPV").count)
            XCTAssertEqual(0, result.successValue()?.quotes(for: "Exec").count)
            XCTAssertEqual(0, result.successValue()?.quotes(for: "Electric").count)
            XCTAssertEqual(0, result.successValue()?.quotes(for: "Moto").count)

            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Searching for quotes
     * When: Availability fails
     * And: Quote list id and Quotes request succeeds
     * Then: Success result should be propogated (quotes)
     // categories will come from quotes in this scenario, not availability
     */
    func testAvailabilityRequestErrorResponse() {
        NetworkStub.errorResponse(path: quoteListIdPath, responseData: RawKarhooErrorFactory.buildError(code: "K5001"))
        NetworkStub.successResponse(jsonFile: "QuotesV2.json", path: quotesPath)

        let expectation = self.expectation(description: "Calls callback with success result")
        pollCall.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            self.assertSuccess(quote: result.successValue()?.all[0])
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Searching for quotes
     * When: QuotesListId fails (no availability)
     * Then: Expected error should be propogated
     */
    func testQuoteListIdRequestErrorResponse() {
        NetworkStub.errorResponse(path: quoteListIdPath, responseData: RawKarhooErrorFactory.buildError(code: "K3002"))
        NetworkStub.successResponse(jsonFile: "QuotesV2.json", path: quotesPath)

        let expectation = self.expectation(description: "Calls callback with error result")
        pollCall.execute(callback: { result in
            XCTAssertEqual(.noAvailabilityInRequestedArea, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Searching for quotes
     * When: Quotes request fails
     * Then: Expected error should be propogated
     */
    func testQuotesRequestErrorResponse() {
        NetworkStub.successResponse(jsonFile: "QuoteListId.json", path: quoteListIdPath)
        NetworkStub.errorResponse(path: quotesPath, responseData: RawKarhooErrorFactory.buildError(code: "K3003"))

        let expectation = self.expectation(description: "Calls callback with error result")
        pollCall.execute(callback: { result in
            XCTAssertEqual(.couldNotFindSpecifiedQuote, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Searching for quotes
     * When: Quotes request succeeds but returns empty json
     * Then: Unknown error should be propogated
     */
    func testQuoteSearchEmptySuccessResult() {
        NetworkStub.successResponse(jsonFile: "QuoteListId.json", path: quoteListIdPath)
        NetworkStub.emptySuccessResponse(path: quotesPath)

        let expectation = self.expectation(description: "Calls callback with error result")
        pollCall.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Searching for quotes
     * When: Quotes request times out
     * Then: Unknown error should be propogated
     */
    func testQuotesRequestTimeout() {
        NetworkStub.successResponse(jsonFile: "QuoteListId.json", path: quoteListIdPath)
        NetworkStub.errorResponseTimeOutConnection(path: quotesPath)

        let expectation = self.expectation(description: "Calls callback with error result")
        pollCall.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
      * Given: Polling for quotes
      * When: The first execution succeeds
      * And: The second execution fails
      * Then: correct results should be propogated
      */
    func testQuoteSearchPolling() {
        NetworkStub.successResponse(jsonFile: "QuoteListId.json", path: quoteListIdPath)
        NetworkStub.successResponse(jsonFile: "Quotes.json", path: quotesPath)

        var quoteSearchResult: [Result<Quotes>] = []
        let expectation = self.expectation(description: "polling returns 2 times")

        let quoteSearchObserver = Observer { (result: Result<Quotes>) in
            quoteSearchResult.append(result)
            NetworkStub.clearStubs()
            NetworkStub.errorResponse(path: self.quotesPath,
                                      responseData: RawKarhooErrorFactory.buildError(code: "K3003"))

            if quoteSearchResult.count == 2 {
                self.assertSuccess(quote: quoteSearchResult[0].successValue()?.all[0])
                XCTAssertEqual(.couldNotFindSpecifiedQuote, quoteSearchResult[1].errorValue()?.type)
                expectation.fulfill()
            }
        }

        let quotesObservable = pollCall.observable(pollTime: 0.1)
        quotesObservable.subscribe(observer: quoteSearchObserver)

        waitForExpectations(timeout: 1)
    }

    private func assertSuccess(quote: Quote?) {
        guard let quote = quote else {
            XCTFail("Quote is nil")
            return
        }

        XCTAssertEqual("someQuoteId", quote.quoteId)
        XCTAssertEqual("Saloon", quote.categoryName)
        XCTAssertEqual("someFleetId", quote.fleetId)
        XCTAssertEqual("someFleetName", quote.fleetName)
        XCTAssertEqual(1, quote.qtaLowMinutes)
        XCTAssertEqual(2, quote.qtaHighMinutes)
        XCTAssertEqual(.estimated, quote.quoteType)
        XCTAssertEqual(7.78, quote.lowPrice)
        XCTAssertEqual(7.79, quote.highPrice)
        XCTAssertEqual("someTermsUrl", quote.termsConditionsUrl)
        XCTAssertEqual("someLogoUrl", quote.supplierLogoUrl)
        XCTAssertEqual("+123", quote.phoneNumber)
        XCTAssertEqual(PickUpType.meetAndGreet, quote.pickUpType)
        XCTAssertEqual(.market, quote.source)
    }
}
