//
//  KarhooQuoteInteractorSpecV2.swift
//  KarhooSDKTests
//
//  Created by Jeevan Thandi on 14/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarooQuoteInteractorSpecV2: XCTestCase {

    private var testObject: KarhooQuoteInteractorV2!
    private var mockQuoteListIdRequest: MockRequestSender!
    private var mockQuotesRequest: MockRequestSender!

    private lazy var mockQuoteSearch: QuoteSearch = {
        return QuoteSearch(origin: LocationInfoMock().set(position: Position(latitude: 0.1, longitude: 0.2)).build(),
                           destination: LocationInfoMock().set(position: Position(latitude: 0.2, longitude: 0.3)).build(),
                           dateScheduled: Date())
    }()

    override func setUp() {
        super.setUp()

        mockQuoteListIdRequest = MockRequestSender()
        mockQuotesRequest = MockRequestSender()

        testObject = KarhooQuoteInteractorV2(quoteListIdRequest: mockQuoteListIdRequest,
                                             quotesRequest: mockQuotesRequest)

        testObject.set(quoteSearch: mockQuoteSearch)
    }

    /**
     * When: Calling execute
     * And: No QuoteSearch is set on the interactor
     * And: No requests should be made
     */
    func testNoQuoteSearchSet() {
        let noQuoteSearchSetInteractor = KarhooQuoteInteractorV2(quoteListIdRequest: mockQuoteListIdRequest,
                                                                 quotesRequest: mockQuotesRequest)

        noQuoteSearchSetInteractor.execute(callback: { (_:Result<Quotes>) in })

        XCTAssertFalse(mockQuoteListIdRequest.requestAndDecodeCalled)
        XCTAssertFalse(mockQuotesRequest.requestAndDecodeCalled)
    }

    /**
     * Given: Searching for Quotes with a dateScheduled
     * When: The timezone is new york
     * Then: The expected pickuptime string, localised in the correct format
     *       Should be propogated to the availabilityRequest
     */
    func testDateScheduledFormatInQuoteRequest() {
        let testDate = Date(timeIntervalSince1970: 1605195000) // UTC: 11/12/2020-15:30

        let testQuoteSearch = QuoteSearch(origin: LocationInfoMock().set(timeZoneIdentifier: "America/New_York")
            .set(placeId: "origin_id")
            .build(),
                                          destination: LocationInfoMock().set(placeId: "destination_id")
                                            .build(),
                                          dateScheduled: testDate)

        testObject.set(quoteSearch: testQuoteSearch)
        testObject.execute(callback: { (_: Result<Quotes>) in })

        let mockQuoteSearchPayload = mockQuotesRequest.payloadSet as? QuoteRequestPayload

        XCTAssertEqual("2020-11-12T10:30", mockQuoteSearchPayload?.dateScheduled)
    }

    /**
     * When: Cancelling Quote Search
     * Then: Availability and QuoteListId request should be cancelled
     * And: QuotePoller should be stopped
     */
    func testCancelQuoteSearch() {
        testObject.cancel()

     //   XCTAssertTrue(mockAvailabilityRequest.cancelNetworkRequestCalled)
        XCTAssertTrue(mockQuoteListIdRequest.cancelNetworkRequestCalled)
    }

    /**
     * Given: Calling execute
     * When: the interactor does not hold a quote list id
     * Then: request for availability should be made
     * And: Quote request should not be called
     */
    func testNoQuoteListId() {
        testObject.execute(callback: { (_: Result<Quotes>) in })

        var dateScheduled: String?
        if let quoteSearchDate = mockQuoteSearch.dateScheduled {
            let dateFormatter = KarhooNetworkDateFormatter(timeZone: mockQuoteSearch.origin.timezone(),
                                                           formatType: .availability)

            dateScheduled = dateFormatter.toString(from: quoteSearchDate)
        }

        let expectedPayload = AvailabilitySearch(origin: mockQuoteSearch.origin.placeId,
                                                 destination: mockQuoteSearch.destination.placeId,
                                                 dateScheduled: dateScheduled)

//        mockAvailabilityRequest.assertRequestSendAndDecoded(endpoint: .availability,
//                                                            method: .get,
//                                                            payload: expectedPayload)

        XCTAssertFalse(mockQuotesRequest.requestAndDecodeCalled)
    }

    /**
     * Given: Calling execute
     * When: The interactor does not hold a quote list id
     * And: the request for availability succeeds
     * Then: quote list id request should be made
     */
    func testRequestAndHandleAvailabilityRequestSuccess() {
        testObject.execute(callback: { (_: Result<Quotes>) in })

//        mockAvailabilityRequest.triggerSuccessWithDecoded(value: mockCategories)
//
//        let availabilityRequestPayload = mockAvailabilityRequest.payloadSet as? AvailabilitySearch
//
//        let expectedPayload = QuoteListIdRequestPayload(origin: mockQuoteSearch.origin.placeId,
//                                                        destination: mockQuoteSearch.destination.placeId,
//                                                        dateScheduled: availabilityRequestPayload?.dateScheduled)
//
//        mockQuoteListIdRequest.assertRequestSendAndDecoded(endpoint: .quoteListId,
//                                                           method: .post,
//                                                           payload: expectedPayload)
    }

    /**
     * Given: Calling execute
     * When: The interactor does not hold a quote list id
     * And: the request for availability fails
     * Then: quote list id request should be made
     */
    func testRequestAndHandleAvailabilityRequestFails() {
        testObject.execute(callback: { (_: Result<Quotes>) in })

//        mockAvailabilityRequest.triggerFail(error: TestUtil.getRandomError())
//        let availabilityRequestPayload = mockAvailabilityRequest.payloadSet as? AvailabilitySearch
//
//        let expectedPayload = QuoteListIdRequestPayload(origin: mockQuoteSearch.origin.placeId,
//                                                        destination: mockQuoteSearch.destination.placeId,
//                                                        dateScheduled: availabilityRequestPayload?.dateScheduled)
//
//        mockQuoteListIdRequest.assertRequestSendAndDecoded(endpoint: .quoteListId,
//                                                           method: .post,
//                                                           payload: expectedPayload)
    }

    /**
     * Given: Calling execute
     * When: The interactor does not hold a quote list id
     * And: the request for availability completes
     * And: quote list id request fails
     * Then: Callback should be propogated
     */
    func testQuoteListIdRequestFails() {
        let expectedError = TestUtil.getRandomError()
        var result: Result<Quotes>?
        testObject.execute(callback: { result = $0 })

       // mockAvailabilityRequest.triggerSuccessWithDecoded(value: mockCategories)
        mockQuoteListIdRequest.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result!.errorValue()!))
    }

    /**
     * Given: Calling execute
     * When: The interactor does not hold a quote list id
     * And: the request for availability completes
     * And: quote list id request succeeds
     * Then: quote request should be made with expected search
     */
    func testQuoteListIdRequestSucceeds() {
        testObject.execute(callback: { (_: Result<Quotes>) in })

     //   mockAvailabilityRequest.triggerSuccessWithDecoded(value: mockCategories)
        mockQuoteListIdRequest.triggerSuccessWithDecoded(value: QuoteListId(identifier: "some", validityTime: 100))

        mockQuotesRequest.assertRequestSendAndDecoded(endpoint: .quotes(identifier: "some"),
                                                      method: .post,
                                                      payload: nil)
    }

    /**
     * Given: Calling execute
     * When: The interactor does not hold a quote list id
     * And: the request for availability completes
     * And: quote list id request succeeds
     * And: quote request succeeds
     * Then: callback should propogate expected value
     */
    func testQuotesRequestSucceeds() {
        var result: Result<Quotes>?
        testObject.execute(callback: { result = $0 })

     //   mockAvailabilityRequest.triggerSuccessWithDecoded(value: mockCategories)
        mockQuoteListIdRequest.triggerSuccessWithDecoded(value: QuoteListId(identifier: "some", validityTime: 100))

        let expectedQuote = QuoteMock().set(quoteId: "foo").set(categoryName: "foo").build()

        let expectedResult = QuoteListMock().set(quoteListId: "some_id")
            .set(status: "some_status")
            .set(validity: 60)
            .add(quoteItem: expectedQuote).build()

        mockQuotesRequest.triggerSuccessWithDecoded(value: expectedResult)

        XCTAssertEqual(expectedQuote.quoteId, result!.successValue()!.quotes(for: "foo")[0].quoteId)
    }

    /**
     * Given: Calling execute
     * When: The interactor does not hold a quote list id
     * And: the request for availability completes
     * And: quote list id request succeeds
     * And: quote request fails
     * Then: quote list id request should be made again
     */
    func testQuotesRequestFails() {
        let expectedError = TestUtil.getRandomError()

        var result: Result<Quotes>?
        testObject.execute(callback: { result = $0 })

     //   mockAvailabilityRequest.triggerSuccessWithDecoded(value: mockCategories)
        mockQuoteListIdRequest.triggerSuccessWithDecoded(value: QuoteListId(identifier: "some", validityTime: 100))

        mockQuotesRequest.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result!.errorValue()))
    }

    /**
     * Given: Calling execute
     * When: The interactor does not hold a quote list id
     * And: the request for availability completes
     * And: quote list id request succeeds
     * And: quote request fails due to K3001
     * Then: quote list id request should be made again
     */
    func testQuotesRequestFailsCouldNotGetEstimate() {
        let expectedError = MockError(code: "K3001", message: "Could not get estimates", userMessage: "some")

        testObject.execute(callback: { (_: Result<Quotes>) in })

      //  mockAvailabilityRequest.triggerSuccessWithDecoded(value: mockCategories)
        mockQuoteListIdRequest.triggerSuccessWithDecoded(value: QuoteListId(identifier: "some", validityTime: 100))

        mockQuoteListIdRequest.requestAndDecodeCalled = false

        mockQuotesRequest.triggerFail(error: expectedError)

      //  XCTAssertTrue(mockAvailabilityRequest.cancelNetworkRequestCalled)
        XCTAssertTrue(mockQuoteListIdRequest.cancelNetworkRequestCalled)
        XCTAssertTrue(mockQuoteListIdRequest.requestAndDecodeCalled)
    }

    /**
     * Given: Calling execute
     * When: the interactor holds a quote list id
     * Then: request for availability should not be made
     * Then: request for quote list id should not be made
     * And: Quote request should be made
     * And: Result should propogate in the callback
     */
    func testQuoteListIdAlreadyPresent() {
        testObject.execute(callback: { (_: Result<Quotes>) in })

 //       mockAvailabilityRequest.triggerSuccessWithDecoded(value: mockCategories)
        mockQuoteListIdRequest.triggerSuccessWithDecoded(value: QuoteListId(identifier: "some", validityTime: 100))

     //   XCTAssertTrue(mockAvailabilityRequest.requestAndDecodeCalled)
        XCTAssertTrue(mockQuoteListIdRequest.requestAndDecodeCalled)
        XCTAssertTrue(mockQuotesRequest.requestAndDecodeCalled)

        // reset
   //     mockAvailabilityRequest.requestAndDecodeCalled = false
        mockQuoteListIdRequest.requestAndDecodeCalled = false
        mockQuotesRequest.requestAndDecodeCalled = false

        var result: Result<Quotes>?
        testObject.execute(callback: { result = $0 })

  //      XCTAssertFalse(mockAvailabilityRequest.requestAndDecodeCalled)
        XCTAssertFalse(mockQuoteListIdRequest.requestAndDecodeCalled)

        XCTAssertTrue(mockQuotesRequest.requestAndDecodeCalled)

        let expectedQuote = QuoteMock().set(quoteId: "foo").set(categoryName: "foo").build()

        let expectedResult = QuoteListMock().set(quoteListId: "some_id")
            .set(status: "some_status")
            .set(validity: 60)
            .add(quoteItem: expectedQuote).build()

        mockQuotesRequest.triggerSuccessWithDecoded(value: expectedResult)

        XCTAssertEqual(expectedQuote.quoteId, result!.successValue()!.quotes(for: "foo")[0].quoteId)
    }

    /**
     * Given: Calling execute
     * When: The interactor does not hold a quote list id
     * And: the request for availability completes
     * And: quote list id request succeeds
     * And: quote request succeeds but contains a quote with an ETA greater than 20 mins
     * Then: callback should propogate empty quotes list
     */
    func testQuoteWithGreaterThan20MinEtaIsFiltered() {
        var result: Result<Quotes>?
        testObject.execute(callback: { result = $0 })

   //     mockAvailabilityRequest.triggerSuccessWithDecoded(value: mockCategories)
        mockQuoteListIdRequest.triggerSuccessWithDecoded(value: QuoteListId(identifier: "some", validityTime: 100))

        let expectedQuote = QuoteMock().set(quoteId: "foo").set(categoryName: "foo").set(qtaHighMinutes: 21).build()

        let expectedResult = QuoteListMock().set(quoteListId: "some_id")
            .set(status: "some_status")
            .set(validity: 60)
            .add(quoteItem: expectedQuote).build()

        mockQuotesRequest.triggerSuccessWithDecoded(value: expectedResult)

        XCTAssertEqual(0, result?.successValue()?.all.count)
    }

    /**
     * Given: Calling execute
     * And: the request for availability completes
     * And: quote list id request succeeds but will expire within 10 seconds
     * Then: callback should not be called and request new QuoteListId
     * When: quote list returns QuoteList with validity above 10
     * Then: callback should be called
     */
    func testValidityTimeRefreshesQuoteList() {
        var result: Result<Quotes>?
        testObject.execute(callback: { result = $0 })

   //    mockAvailabilityRequest.triggerSuccessWithDecoded(value: mockCategories)
        mockQuoteListIdRequest.triggerSuccessWithDecoded(value: QuoteListId(identifier: "some", validityTime: 5))

        let expectedQuote = QuoteMock().set(quoteId: "foo").set(categoryName: "foo").build()

        let quotesWithExpiringValidity = QuoteListMock().set(quoteListId: "some_id")
            .set(status: "some_status")
            .set(validity: 5)
            .add(quoteItem: expectedQuote).build()

        mockQuotesRequest.triggerSuccessWithDecoded(value: quotesWithExpiringValidity)

        XCTAssertNil(result)

        mockQuoteListIdRequest.triggerSuccessWithDecoded(value: QuoteListId(identifier: "some", validityTime: 5))

        let validQuoteList = QuoteListMock().set(quoteListId: "some_id")
            .set(status: "some_status")
            .set(validity: 300)
            .add(quoteItem: expectedQuote).build()

        mockQuotesRequest.triggerSuccessWithDecoded(value: validQuoteList)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.isSuccess())
    }

}
