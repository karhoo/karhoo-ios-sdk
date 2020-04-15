//
//  RequestTesting.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooSDK

final class RequestTesting {
    private let httpClient: MockHttpClient

    init(httpClient: MockHttpClient) {
        self.httpClient = httpClient
    }

    func assertRequestSend(endpoint: APIEndpoint, headers: HttpHeaders? = nil, body: Data) {
        XCTAssertTrue(httpClient.sendRequestsCount > 0)
        XCTAssertEqual(httpClient.lastRequestMethod, endpoint.method)
        XCTAssertEqual(httpClient.lastRequestPath, endpoint.path)
        XCTAssertEqual(httpClient.lastRequestEndpoint, endpoint)
        guard let setBody = httpClient.lastRequestBody else {
            return
        }
        XCTAssertEqual(setBody, body)
    }
}
