//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class HeaderProviderSpec: XCTestCase {

    private var testAccessTokenProvider: AccessTokenProvider!
    private var testHeaderProvider: HeaderProvider!
    private var testAuthCredentials: Credentials!

    override func setUp() {
        super.setUp()

        let testDataStore = MockUserDataStore()
        testAuthCredentials = ObjectTestFactory.getRandomCredentials()
        testDataStore.credentialsToReturn = testAuthCredentials
        testAccessTokenProvider = DefaultAccessTokenProvider(userStore: testDataStore)

        testHeaderProvider = KarhooHeaderProvider(authTokenProvider: testAccessTokenProvider)
    }

    /**
    *  Given:  A user makes a login request
    *  When:   They add the auth token
    *  Then:   The auth token shouldn't be added as its not needed
    */
    func testAddingAuthTokenToLoginEndpointDoesntAddToken() {
        var headers = HttpHeaders()
        headers = testHeaderProvider.headersWithAuthorization(headers: &headers, endpoint: .login)

        XCTAssertEqual(0, headers.count)
    }

    /**
    *  Given:  A user makes a refresh request
    *  When:   They add the auth token
    *  Then:   The auth token shouldn't be added as its not needed
    */
    func testAddingAuthTokenToRefreshEndpointDoesntAddToken() {
        var headers = HttpHeaders()
        headers = testHeaderProvider.headersWithAuthorization(headers: &headers, endpoint: .karhooUserTokenRefresh)

        XCTAssertEqual(0, headers.count)
    }

    /**
     *  Given:  Custom http headers provided
     *  When:   One of the headers is the authorization headers
     *  Then:   Custom headers should be set
     *   And:   Authorization header should be set accordingly
     *   And:   Global custom http headers should be set correctly
     */
    func testRequestWithAuthProvidedHeaders() {
        var httpHeaders = ["foo": "bar"]

        httpHeaders = testHeaderProvider.headersWithAuthorization(headers: &httpHeaders, endpoint: .bookTrip)
        httpHeaders = testHeaderProvider.headersWithJSONContentType(headers: &httpHeaders)

        XCTAssertEqual(httpHeaders["foo"], "bar")
        XCTAssertEqual(httpHeaders["Content-Type"], "application/json")
        XCTAssertEqual(httpHeaders["authorization"], "Bearer \(testAuthCredentials.accessToken)")
    }

    /**
    *  Given:  A set of headers with some values
    *  When:   Adding a new header
    *  Then:   The combine func should return a combination of two headers
    */
    func testAddingTwoHeadersTogetherUsingCombineMergesTheTwoHeadersIntoOne() {
        var httpHeadersOne = ["foo": "bar"]
        let httpHeadersTwo = ["bar": "foo"]

        let finalHeaders = testHeaderProvider.combine(headers: &httpHeadersOne, with: httpHeadersTwo)

        XCTAssertEqual("bar", finalHeaders["foo"])
        XCTAssertEqual("foo", finalHeaders["bar"])
    }

    /**
    *  Given:  A network request is made
    *  When:   The payload type is json
    *  Then:   The content type should be of the correct value
    */
    func testAddingJsonContentTypeGetsAppendedToTheHeader() {
        var httpHeader = ["foo": "bar"]

        let finalHeaders = testHeaderProvider.headersWithJSONContentType(headers: &httpHeader)

        XCTAssertEqual("bar", finalHeaders["foo"])
        XCTAssertEqual("application/json", finalHeaders["Content-Type"])
    }
    
    /**
    *  Given:  A network request is made
    *  When:   The payload type is accept with json
    *  Then:   The content type should be of the correct value
    */
    func testAddingAcceptJsonTypeGetsAppendedToTheHeader() {
        var httpHeader = ["foo": "bar"]

        let finalHeaders = testHeaderProvider.headersWithAcceptJSONType(headers: &httpHeader)

        XCTAssertEqual("bar", finalHeaders["foo"])
        XCTAssertEqual("application/json", finalHeaders["accept"])
    }

    /**
    *  Given:  A network request is made
    *  When:   Adding a correlation id
    *  Then:   the correlation id should be appended
    */
    func testSettingCorrelationIdAppendsOntoHeaders() {
        var httpHeader = ["foo": "bar"]

        let finalHeaders = testHeaderProvider.headersWithCorrelationId(headers: &httpHeader,
                                                                       endpoint: .bookTrip)
        let correlationId: String = finalHeaders["correlation_id"] ?? ""

        let prefix = String(correlationId.prefix(HeaderConstants.correlationIdPrefix.count))
        let daRest = correlationId.replacingOccurrences(of: HeaderConstants.correlationIdPrefix, with: "")

        XCTAssertEqual("bar", finalHeaders["foo"])
        XCTAssertEqual(HeaderConstants.correlationIdPrefix, prefix)
        XCTAssertNotEqual("", daRest)
    }

    /**
    *  Given:  A request is made to retrieve a correlation id for a quote
    *  When:   Adding a header to the request
    *  Then:   The quote correlation id should be saved=
    */
    func testMakingABookingRequestUsesTheSameIdAsQuote() {
        var headers = HttpHeaders()
        let quoteHeaders = testHeaderProvider.headersWithCorrelationId(headers: &headers,
                                                                       endpoint: .quoteListId)
        let bookingHeaders = testHeaderProvider.headersWithCorrelationId(headers: &headers,
                                                                         endpoint: .bookTrip)

        XCTAssertEqual(quoteHeaders, bookingHeaders)
    }

    /**
    *  Given:  A request has been made to quotes
    *  When:   A second request is made to quotes
    *  Then:   The Ids should be different
    */
    func testMultipleQuoteRequestsGenerateDifferentIds() {
        var headers = HttpHeaders()
        let quoteHeadersOne = testHeaderProvider.headersWithCorrelationId(headers: &headers,
                                                                          endpoint: .quoteListId)
        let quoteHeadersTwo = testHeaderProvider.headersWithCorrelationId(headers: &headers,
                                                                          endpoint: .quoteListId)

        XCTAssertNotEqual(quoteHeadersOne, quoteHeadersTwo)
    }

    /**
    *  Given:  A request has been made to booking
    *  When:   There is no quote correlation id saved
    *  Then:   A new id should be generated
    */
    func testNoSavedQuoteCorrelationIdCreatesOneForBooking() {
        var headers = HttpHeaders()
        let bookingHeaders = testHeaderProvider.headersWithCorrelationId(headers: &headers,
                                                                         endpoint: .bookTrip)

        let correlationId: String = bookingHeaders["correlation_id"] ?? ""

        let prefix = String(correlationId.prefix(HeaderConstants.correlationIdPrefix.count))
        let daRest = correlationId.replacingOccurrences(of: HeaderConstants.correlationIdPrefix, with: "")

        XCTAssertEqual(HeaderConstants.correlationIdPrefix, prefix)
        XCTAssertNotEqual("", daRest)
    }
}
