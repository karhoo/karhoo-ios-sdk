import Foundation

@testable import KarhooSDK

public class MockURLSessionSender: URLSessionSender {
    private(set) var lastRequest: URLRequest?
    var mockResponse: (data: Data?, response: URLResponse?, error: Error?)? //swiftlint:disable:this large_tuple

    public func send(request: URLRequest,
                     completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkRequest {
        lastRequest = request
        completion(mockResponse?.0, mockResponse?.1, mockResponse?.2)
        return MockNetworkRequest()
    }
}
