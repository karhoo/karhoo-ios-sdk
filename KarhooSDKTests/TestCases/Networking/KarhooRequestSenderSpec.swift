//
//  KarhooRequestSenderSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooRequestSenderSpec: XCTestCase {

    private var testRequestSender: KarhooRequestSender!
    private var mockHttpClient: MockHttpClient!
    private var requestTesting: RequestTesting!
    private var mockPayload: MockPayload!

    let endpoint = APIEndpoint.availability

    override func setUp() {
        mockPayload = MockPayload(value: "some")
        mockHttpClient = MockHttpClient()
        requestTesting = RequestTesting(httpClient: mockHttpClient)
        testRequestSender = KarhooRequestSender(httpClient: mockHttpClient)

        super.setUp()
    }

  /**
    * When: Sending a request
    * Then: The correct request should be sent
    */
    func testRequest() {
        testRequestSender.request(payload: mockPayload, endpoint: endpoint, callback: { _ in})

        XCTAssertEqual(1, mockHttpClient.sendRequestsCount)
        requestTesting.assertRequestSend(endpoint: endpoint, body: mockPayload.encode()!)
    }

    /**
      * When: Request is successful
      * Then: Correct callback should be propogated
      */
    func testSuccessRequest() {
        var requestCallback: Result<HttpResponse>?

        testRequestSender.request(payload: mockPayload,
                                  endpoint: endpoint,
                                  callback: { (response: Result<HttpResponse>) in
            requestCallback = response
        })

        let response = HttpResponse(code: 200, data: mockPayload.encode()!)
        let success = Result.success(result: response)
        mockHttpClient.lastCompletion?(success)

        XCTAssertTrue(requestCallback!.isSuccess())
        XCTAssertEqual(requestCallback?.successValue()?.data, mockPayload.encode()!)
    }

    /**
     * When: Request is successful
     * Then: Correct callback should be propogated
     */
    func testRequestFails() {
        var requestCallback: Result<HttpResponse>?
        testRequestSender.request(payload: mockPayload,
                                  endpoint: endpoint,
                                  callback: { (response: Result<HttpResponse>) in
                                    requestCallback = response
        })

        let responseError = TestUtil.getRandomError()
        mockHttpClient.lastCompletion?(Result.failure(error: responseError))

        XCTAssertFalse(requestCallback!.isSuccess())
        XCTAssertEqual(requestCallback?.errorValue()?.localizedDescription, responseError.localizedDescription)
    }
}

struct MockPayload: KarhooCodableModel {
    var value: String
}

