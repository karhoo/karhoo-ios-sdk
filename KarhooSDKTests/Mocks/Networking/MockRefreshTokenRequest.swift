//
//  MockRefreshTokenRequest.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

class MockRefreshTokenRequest: RequestSender {

    var payloadSet: KarhooRequestModel?
    var endpointSet: APIEndpoint?
    var requestCalled = false
    var beforeResponse: (() -> Void)!
    private var errorCallback: ((KarhooError) -> Void)?
    private var valueCallback: ((Any) -> Void)?

    func request(payload: KarhooRequestModel?,
                 endpoint: APIEndpoint,
                 callback: @escaping CallbackClosure<HttpResponse>) {
        fatalError("Not Implemented")
    }

    func requestAndDecode<T: KarhooCodableModel>(payload: KarhooRequestModel?,
                                                 endpoint: APIEndpoint,
                                                 callback: @escaping CallbackClosure<T>) {
        requestCalled = true
        payloadSet = payload
        endpointSet = endpoint
        self.errorCallback = { error in
            callback(.failure(error: error))
        }
        self.valueCallback = { value in
            guard let value = value as? T else { return }
            callback(.success(result: value))
        }
    }

    func encodedRequest<T: KarhooCodableModel>(endpoint: APIEndpoint,
                                               body: URLComponents?,
                                               callback: @escaping CallbackClosure<T>) {
        requestCalled = true
        endpointSet = endpoint
        self.errorCallback = { error in
            callback(.failure(error: error))
        }
        self.valueCallback = { value in
            guard let value = value as? T else { return }
            callback(.success(result: value))
        }
    }

    func cancelNetworkRequest() {}

    func success(response: KarhooCodableModel) {
        beforeResponse?()
        valueCallback?(response)
    }

    func fail(error: KarhooError = TestUtil.getRandomError()) {
        beforeResponse?()
        errorCallback?(error)
    }

    func assertRequestSend(endpoint: APIEndpoint,
                           method: HttpMethod? = nil,
                           path: String? = nil,
                           payload: KarhooCodableModel? = nil) {
        XCTAssertTrue(requestCalled)
        XCTAssertEqual(endpoint, endpointSet)
        XCTAssertEqual(method ?? endpoint.method, endpointSet?.method)
        XCTAssertEqual(path ?? endpoint.path, endpointSet?.path)

        // test payload only if it's set
        if let payload = payload {
            XCTAssertNotNil(payloadSet)
            XCTAssertEqual(payload.encode(), payloadSet?.encode())
        }
    }
}
