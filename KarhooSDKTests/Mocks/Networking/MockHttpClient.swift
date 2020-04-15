import Foundation

@testable import KarhooSDK

/**
 *  Unlike JSONHttpClient, MockHttpClient doesn't add any headers
 *  (in particular it doesn't add an Authentication header)
 */
class MockHttpClient: HttpClient {

    var networkRequestToReturn: NetworkRequest?

    func sendRequest(endpoint: APIEndpoint,
                     data: Data? = nil,
                     urlComponents: URLComponents? = nil,
                     completion: @escaping CallbackClosure<HttpResponse>) -> NetworkRequest? {
        sendRequestsCount += 1
        lastRequestEndpoint = endpoint
        lastRequestBody = data
        lastCompletion = completion
        return networkRequestToReturn
    }

    private(set) var sendRequestsCount: Int = 0
    private(set) var lastRequestEndpoint: APIEndpoint?
    var lastRequestMethod: HttpMethod? {
        return lastRequestEndpoint?.method
    }
    var lastRequestPath: String? {
        return lastRequestEndpoint?.path
    }
    private(set) var lastRequestBody: Data?
    private(set) var lastCompletion: CallbackClosure<HttpResponse>?

}
