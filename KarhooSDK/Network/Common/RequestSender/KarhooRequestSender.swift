//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooRequestSender: RequestSender {

    private let httpClient: HttpClient
    private var networkRequest: NetworkRequest?

    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }

    func request(payload: KarhooRequestModel?,
                 endpoint: APIEndpoint,
                 callback: @escaping CallbackClosure<HttpResponse>) {
        networkRequest = httpClient.sendRequest(endpoint: endpoint,
                                                data: payload?.encode(),
                                                urlComponents: nil,
                                                completion: callback)
    }

    func requestAndDecode<T: KarhooCodableModel>(payload: KarhooRequestModel?,
                                                 endpoint: APIEndpoint,
                                                 callback: @escaping CallbackClosure<T>) {
        request(payload: payload,
                endpoint: endpoint) { [weak self] response in
            self?.handler(response: response, callback: callback)
        }
    }

    func encodedRequest<T: KarhooCodableModel>(endpoint: APIEndpoint, body: URLComponents?, callback: @escaping CallbackClosure<T>) {
        networkRequest = httpClient.sendRequest(endpoint: endpoint,
                                                data: nil,
                                                urlComponents: body,
                                                completion: { [weak self] response in
                                                    self?.handler(response: response, callback: callback)
                                                })
    }

    private func handler<T: KarhooCodableModel>(response: Result<HttpResponse>, callback: @escaping CallbackClosure<T>) {
        if let value = response.getSuccessValue()?.decodeData(ofType: T.self) {
            callback(.success(result: value, correlationId: response.getCorrelationId()))
        } else {
            if let error = response.getErrorValue() {
                callback(.failure(error: error, correlationId: response.getCorrelationId()))
            } else {
                callback(.failure(error: SDKErrorFactory.unexpectedError(), correlationId: response.getCorrelationId()))
            }
        }
    }

    func cancelNetworkRequest() {
        networkRequest?.cancel()
    }
}
