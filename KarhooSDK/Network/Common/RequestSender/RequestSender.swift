//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol RequestSender {
    func request(payload: KarhooRequestModel?,
                 endpoint: APIEndpoint,
                 callback: @escaping CallbackClosure<HttpResponse>)

    func requestAndDecode<T: KarhooCodableModel>(payload: KarhooRequestModel?,
                                                 endpoint: APIEndpoint,
                                                 callback: @escaping CallbackClosure<T>)

    func requestAndDecode<T: KarhooCodableModel>(payload: KarhooRequestModel?,
                                                 endpoint: APIEndpoint,
                                                 callback: @escaping CallbackClosureWithCorrelationId<T>)

    func encodedRequest<T: KarhooCodableModel>(endpoint: APIEndpoint,
                                               body: URLComponents?,
                                               callback: @escaping CallbackClosure<T>)

    func cancelNetworkRequest()
}

extension RequestSender {
    func encodedRequest<T: KarhooCodableModel>(endpoint: APIEndpoint,
                                               body: URLComponents?,
                                               callback: @escaping CallbackClosure<T>) {}
}
