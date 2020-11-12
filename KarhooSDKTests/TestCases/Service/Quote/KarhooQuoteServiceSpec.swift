//
//  KarhooQuoteServiceSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooQuoteServiceSpec: XCTestCase {

    private var testobject: KarhooQuoteService!
    private var mockQuoteInteractor = MockQuoteInteractor()
    private var mockCoverageInteractor = MockCoverageInteractor()

    private let mockQuoteSearch: QuoteSearch = QuoteSearch(origin: LocationInfoMock()
                                                                   .set(placeId: "originPlaceId")
                                                                   .build(),
                                                           destination: LocationInfoMock()
                                                                        .set(placeId: "destinationPlaceId")
                                                                        .build(),
                                                           dateScheduled: Date())

    private let mockCoverageRequestPayload: QuoteCoverageRequest = QuoteCoverageRequest(latitude: "", longitude: "", localTimeOfPickup: "")
    
    let mockCoverageResult = QuoteCoverage(coverage: true)
    
    static let mockFleet = FleetInfo(id: "success-quotev2")
    static let mockQuote = QuoteMock().set(quoteId: "success-quote").set(categoryName: "foo").set(fleet: mockFleet).build()
    let mockQuotesResult = Quotes(quoteListId: "some",
                                  quoteCategories: [QuoteCategory(name: "foo", quotes: [mockQuote])],
                                  all: [mockQuote])

    override func setUp() {
        super.setUp()

        mockQuoteInteractor = MockQuoteInteractor()

        testobject = KarhooQuoteService(quoteInteractor: mockQuoteInteractor, coverageInteractor: mockCoverageInteractor)
    }

    /**
      * When: Quote search succeeds
      * Then: callback should be executed with expected value
      */
    func testQuoteSearchSucces() {
        let pollCall = testobject.quotes(quoteSearch: mockQuoteSearch)

        var result: Result<Quotes>?
        pollCall.execute(callback: { result = $0 })

        mockQuoteInteractor.triggerSuccess(result: mockQuotesResult)

        XCTAssertEqual("success-quotev2", result?.successValue()?.quotes(for: "foo")[0].fleet.id)
    }

    /**
     * When: Quote search fails
     * Then: callback should be executed with expected value
     */
    func testQuoteSearchFails() {
        let pollCall = testobject.quotes(quoteSearch: mockQuoteSearch)

        var result: Result<Quotes>?
        pollCall.execute(callback: { result = $0 })

        let expectedError = TestUtil.getRandomError()
        mockQuoteInteractor.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result?.errorValue()))
    }
    
    /**
      * When: Quote coverage succeeds
      * Then: callback should be executed with expected value
      */
    func testCoverageSucces() {
        let call = testobject.coverage(coverageRequest: mockCoverageRequestPayload)

        var result: Result<QuoteCoverage>?
        call.execute(callback: { result = $0 })

        mockCoverageInteractor.triggerSuccess(result: mockCoverageResult)
        XCTAssertTrue(result!.isSuccess())
    }

    /**
     * When: Quote coverage fails
     * Then: callback should be executed with expected value
     */
    func testCoverageFails() {
        let call = testobject.coverage(coverageRequest: mockCoverageRequestPayload)

        var result: Result<QuoteCoverage>?
        call.execute(callback: { result = $0 })

        let expectedError = TestUtil.getRandomError()
        mockCoverageInteractor.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result?.errorValue()))
    }
}
