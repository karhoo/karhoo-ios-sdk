import Foundation

public protocol NetworkRequest {
    func cancel()
}

protocol HttpClient {
    func sendRequest(
        endpoint: APIEndpoint,
        data: Data?,
        urlComponents: URLComponents?,
        completion: @escaping CallbackClosure<HttpResponse>
    ) -> NetworkRequest?

    func sendRequestWithCorrelationId(
        endpoint: APIEndpoint,
        data: Data?,
        urlComponents: URLComponents?,
        //correlationId: String,
        completion: @escaping CallbackClosureWithCorrelationId<HttpResponse>
    ) -> NetworkRequest?
}
