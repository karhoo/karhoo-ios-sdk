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
    private var mockQuoteInteractor: MockQuoteInteractor!
    private var mockQuoteInteractorV2 = MockQuoteInteractorV2()

    private let mockQuoteSearch: QuoteSearch = QuoteSearch(origin: LocationInfoMock()
                                                                   .set(placeId: "originPlaceId")
                                                                   .build(),
                                                           destination: LocationInfoMock()
                                                                        .set(placeId: "destinationPlaceId")
                                                                        .build(),
                                                           dateScheduled: Date())

    static let mockFleet = FleetInfo(id: "success-quotev2")
    static let mockQuote = QuoteMock().set(quoteId: "success-quote").set(categoryName: "foo").set(fleet: mockFleet).build()
    let mockQuotesResult = Quotes(quoteListId: "some",
                                  quoteCategories: [QuoteCategory(name: "foo", quotes: [mockQuote])],
                                  all: [mockQuote])

    override func setUp() {
        super.setUp()

        mockQuoteInteractor = MockQuoteInteractor()

        testobject = KarhooQuoteService(quoteInteractor: mockQuoteInteractor, quoteV2Interactor: mockQuoteInteractorV2)
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

        XCTAssertEqual("success-quote", result?.successValue()?.quotes(for: "foo")[0].quoteId)
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
      * When: QuoteV2 search succeeds
      * Then: callback should be executed with expected value
      */
    func testQuoteV2SearchSucces() {
        let pollCall = testobject.quotesV2(quoteSearch: mockQuoteSearch)

        var result: Result<Quotes>?
        pollCall.execute(callback: { result = $0 })

        mockQuoteInteractorV2.triggerSuccess(result: mockQuotesResult)

        XCTAssertEqual("success-quotev2", result?.successValue()?.quotes(for: "foo")[0].fleet.id)
    }

    /**
     * When: Quote search fails
     * Then: callback should be executed with expected value
     */
    func testQuoteV2SearchFails() {
        let pollCall = testobject.quotesV2(quoteSearch: mockQuoteSearch)

        var result: Result<Quotes>?
        pollCall.execute(callback: { result = $0 })

        let expectedError = TestUtil.getRandomError()
        mockQuoteInteractorV2.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result?.errorValue()))
    }
}
