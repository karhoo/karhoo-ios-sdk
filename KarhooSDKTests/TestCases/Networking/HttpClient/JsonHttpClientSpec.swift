//
//  JsonHttpClientSpec.swift
//  KarhooSDKTests
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class JsonHttpClientSpec: XCTestCase {

    private var testObject: JsonHttpClient!
    private var capturedResult: Result<HttpResponse>?
    private var mockURLSessionSender: MockURLSessionSender!
    private var testHeaderProvider: HeaderProvider!
    private var testAccessTokenProvider: AccessTokenProvider!
    private var testAuthCredentials: Credentials!
    private var testDataStore: MockUserDataStore!
    private var testAnalytics: MockAnalyticsService!
    
    override func setUp() {
        super.setUp()

        mockURLSessionSender = MockURLSessionSender()
        testDataStore = MockUserDataStore()
        testAuthCredentials = ObjectTestFactory.getRandomCredentials()
        testDataStore.credentialsToReturn = testAuthCredentials
        testAccessTokenProvider = DefaultAccessTokenProvider(userStore: testDataStore)
        testHeaderProvider = KarhooHeaderProvider(authTokenProvider: testAccessTokenProvider)
        testAnalytics = MockAnalyticsService()
        
        testObject = JsonHttpClient(urlSessionSender: mockURLSessionSender,
                                    headerProvider: testHeaderProvider,
                                    analyticsService: testAnalytics)
    }

    /**
     *  When: Sending a request
     *  Then: Request is send
     */
    func testRequestSend() {
        sendSampleRequest()

        XCTAssertTrue(mockURLSessionSender.lastRequest != nil)
    }

    /**
     *  When: Request is send
     *  Then: Absolute API URL should be correct
     */
    func testRelativeApiUrl() {
        sendSampleRequest()

        let url = mockURLSessionSender.lastRequest?.url
        XCTAssertEqual("https://rest.sandbox.karhoo.com/v1/demand/mockPath", url?.absoluteString ?? "")
    }

    /**
     *  Given: Karhoo user authentication method is set up
     *  When: Request is sent
     *  Then: Base url should be set
     */
    func testKarhooUserAuthenticationMethodBaseURL() {
        sendSampleRequest(path: "")

        let baseUrl = mockURLSessionSender.lastRequest?.url?.host
        XCTAssertEqual("rest.sandbox.karhoo.com", baseUrl)
    }

    /**
     *  Given: Karhoo user authentication method is set up
     *  When: Request is sent
     *  Then: Base url should be set
     */
    func testAuthServiceBaseURL() {
        MockSDKConfig.authenticationMethod = .tokenExchange(settings: MockSDKConfig.tokenExchangeSettings)
        let authEndpoints: [APIEndpoint] = [.authRevoke, .authRefresh, .authUserInfo, .authTokenExchange]

        authEndpoints.forEach { endpoint in
            sendToEndpoint(endpoint: endpoint)

            let baseUrl = mockURLSessionSender.lastRequest?.url?.host

            XCTAssertEqual("sso.sandbox.karhoo.com", baseUrl)
        }
    }

    /**
     *  Given: Anonymous user authentication method is set up
     *  When: Request is sent
     *  Then: Base url should be set
     *  And: API key should be set
     */
    func testAnonymousAuthBaseURLAndAuthorisationHeaders() {
        MockSDKConfig.authenticationMethod = .guest(settings: MockSDKConfig.guestSettings)
        sendToEndpoint(endpoint: .locationInfo)

        let url = mockURLSessionSender.lastRequest?.url?.host
        let httpHeaders = mockURLSessionSender.lastRequest?.allHTTPHeaderFields

        XCTAssertEqual(httpHeaders?[HeaderConstants.identifier], MockSDKConfig.guestSettings.identifier)
        XCTAssertEqual(httpHeaders?["Referer"], MockSDKConfig.guestSettings.referer)
        XCTAssertEqual("public-api.sandbox.karhoo.com", url)
    }

    /**
     *  Given:  Custom http headers provided
     *  When:   Post request is send
     *   And:   Authorization header should be set correctly
     *   And:   Content-type header should be set correctly
     *   And:   Request interceptor headers should be added
     */
    func testAuthorisationRequest() {
        MockSDKConfig.authenticationMethod = .karhooUser
        sendSampleRequest(method: .post)
        let httpHeaders = mockURLSessionSender.lastRequest?.allHTTPHeaderFields

        XCTAssertEqual(httpHeaders?["Content-Type"], "application/json")
        XCTAssertEqual(httpHeaders?["Authorization"], "Bearer \(testAuthCredentials.accessToken)")
    }

    /**
     *  Given:  Empty Authorization header provided
     *   When:  Sending the request
     *   Then:  Authorization header should remain empty
     */
    func testRequestWithEmptyAuthHeader() {
        testDataStore.credentialsToReturn = nil

        sendSampleRequest(method: .post)

        guard let httpHeaders = mockURLSessionSender.lastRequest?.allHTTPHeaderFields else {
            XCTFail("Could not set headers")
            return
        }
        let token = httpHeaders["Authorization"]
        XCTAssertEqual(token, nil)
    }

    /**
     *  Given: Request response is empty
     *  When: Request is send
     *  Then: Completion callback should receive success with empty response details
     */
    func testEmptyResponse() {
        var capturedResult: Result<HttpResponse>?
        mockURLSessionSender.mockResponse = (nil, nil, nil)

        sendSampleRequest(completion: { result in
            capturedResult = result
        })

        XCTAssertTrue(capturedResult?.isSuccess() == true)
        let httpResponse: HttpResponse? = capturedResult?.successValue()
        XCTAssertNotNil(httpResponse)

        XCTAssertTrue(httpResponse!.code == 0)
        XCTAssertTrue(httpResponse!.data == Data())
    }

    /**
     *  Given: Request response is a valid json
     *  When: Request is send
     *  Then: Completion callback should receive success with correct response details
     */
    func testJsonResponse() {
        let mockData = try? JSONSerialization.data(withJSONObject: [
            "foo": "bar"
        ])

        mockURLSessionSender.mockResponse = (mockData, mockURLResponse(), nil)

        sendSampleRequest()

        XCTAssertTrue(capturedResult?.isSuccess() == true)
        let httpResponse: HttpResponse? = capturedResult?.successValue()
        XCTAssertNotNil(httpResponse)

        XCTAssertTrue(httpResponse!.code == 201)
        XCTAssertTrue(httpResponse!.data == mockData)
    }

    /**
     *  Given: Request response is an empty json
     *  When: Request is send
     *  Then: Completion callback should receive success with correct response details
     */
    func testEmptyJsonResponse() {
        mockURLSessionSender.mockResponse = (Data(), nil, nil)

        sendSampleRequest()

        XCTAssertTrue(capturedResult?.isSuccess() == true)
        let httpResponse: HttpResponse? = capturedResult?.successValue()
        XCTAssertNotNil(httpResponse)

        XCTAssertTrue(httpResponse!.code == 0)
        XCTAssertTrue(httpResponse!.data == Data())
    }

    /**
     *  Given: Request response is an error
     *  When: Request is send
     *  Then: Completion callback should receive an error and no status code
     */
    func testErrorResponse() {
        let expectedError = NSError(domain: "test", code: 22, userInfo: [:])
        mockURLSessionSender.mockResponse = (nil, nil, expectedError)

        sendSampleRequest()

        XCTAssertTrue(capturedResult?.isSuccess() == false)
        let httpResponse: HttpResponse? = capturedResult?.successValue()
        XCTAssertNil(httpResponse)
        XCTAssertNotNil(capturedResult!.errorValue())
    }

    /**
     *  Given: Request response status code is an error
     *  When: Request is send
     *  Then: Completion callback should receive an error
     */
    func testErrorResponseCode() {
        let errorCode = HttpStatus.badRequest.rawValue
        let response = mockURLResponse(statusCode: errorCode)
        mockURLSessionSender.mockResponse = (Data(), response, nil)

        sendSampleRequest()

        XCTAssertTrue(capturedResult?.isSuccess() == false)
        let errorValue = capturedResult?.errorValue() as? HTTPError
        XCTAssertEqual(errorCode, errorValue?.statusCode)
    }
    
    /**
     *  Given: Request response is an error
     *  When: Request is send
     *  Then: An analytic event is sent to notify the error
     */
    func testErrorResponseAnalyticSent() {
        let expectedError = NSError(domain: "test", code: 22, userInfo: [:])
        mockURLSessionSender.mockResponse = (nil, nil, expectedError)

        sendSampleRequest()
        
        XCTAssertEqual(testAnalytics.eventSent, AnalyticsConstants.EventNames.requestFails)
    }
}

private extension JsonHttpClientSpec {
    func sendSampleRequest(method: HttpMethod = .post,
                           path: String = "/v1/demand/mockPath",
                           completion: CallbackClosure<HttpResponse>? = nil) {
        _ = testObject.sendRequest(endpoint: .custom(path: path, method: method),
                                   completion: completion ?? self.saveResponse)
    }

    func sendToEndpoint(endpoint: APIEndpoint, completion: CallbackClosure<HttpResponse>? = nil) {
        _ = testObject.sendRequest(endpoint: endpoint, completion: completion ?? self.saveResponse)
    }
    func saveResponse(_ result: Result<HttpResponse>) {
        capturedResult = result
    }

    func mockURLResponse(statusCode: Int = 201) -> HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: "www.google.pl")!,
                statusCode: statusCode,
                httpVersion: "1.0",
                headerFields: nil)!
    }
}
