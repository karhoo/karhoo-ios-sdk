//
//  MockRequestSender.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

final class MockRequestSender: RequestSender {

    var payloadSet: KarhooCodableModel?
    var endpointSet: APIEndpoint?
    // regular request
    var requestCallback: CallbackClosure<HttpResponse>?
    var requestCalled = false
    func request(payload: KarhooCodableModel?,
                 endpoint: APIEndpoint,
                 callback: @escaping CallbackClosure<HttpResponse>) {
        requestCalled = true
        payloadSet = payload
        endpointSet = endpoint
        requestCallback = callback
    }

    var requestAndDecodeCalled = false

    // Using Any to avoid specifying class generics for each instance of TestRequestSender
    private var errorCallback: ((KarhooError) -> Void)?
    private var valueCallback: ((Any) -> Void)?
    func requestAndDecode<T: KarhooCodableModel>(payload: KarhooCodableModel?,
                                                 endpoint: APIEndpoint,
                                                 callback: @escaping CallbackClosure<T>) {
        self.requestAndDecodeCalled = true
        self.payloadSet = payload
        self.endpointSet = endpoint

        self.errorCallback = { error in
            callback(.failure(error: error))
        }
        self.valueCallback = { value in
            guard let value = value as? T else {
                return
            }
            callback(.success(result: value))
        }
    }

    private var encodedRequestCallback: ((Any) -> Void)?
    private var encodedRequestErrorCallback: ((KarhooError) -> Void)?
    var encodedRequestCalled = false
    var bodySet: URLComponents?
    func encodedRequest<T: KarhooCodableModel>(endpoint: APIEndpoint, body: URLComponents?, callback: @escaping CallbackClosure<T>) {
        self.bodySet = body
        self.endpointSet = endpoint

        self.encodedRequestErrorCallback = { error in
            callback(.failure(error: error))
        }

        self.encodedRequestCallback = { value in
            guard let value = value as? T else { return }
            callback(.success(result: value))
        }
    }

    var cancelNetworkRequestCalled = false
    func cancelNetworkRequest() {
        cancelNetworkRequestCalled = true
    }

    // MARK: Test functions
    func triggerSuccess(response: Data) {
        let success = Result.success(result: HttpResponse(code: 200, data: response))
        requestCallback?(success)
    }

    func triggerSuccessWithDecoded(value: KarhooCodableModel) {
        valueCallback?(value)
    }

    func triggerFail(error: KarhooError = TestUtil.getRandomError()) {
        requestCallback?(.failure(error: error))
        errorCallback?(error)
        encodedRequestErrorCallback?(error)
    }

    func triggerEncodedRequestSuccess(value: KarhooCodableModel) {
        encodedRequestCallback?(value)
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

    func assertRequestSendAndDecoded(endpoint: APIEndpoint,
                                     method: HttpMethod,
                                     payload: KarhooCodableModel? = nil) {
        XCTAssertTrue(requestAndDecodeCalled)
        XCTAssertEqual(endpoint, endpointSet)
        XCTAssertEqual(endpoint.method, endpointSet?.method)

        // test payload only if it's set
        if let payload = payload {
            XCTAssertNotNil(payloadSet)
            XCTAssertEqual(payload.encode(), payloadSet?.encode())
        }
    }
}
