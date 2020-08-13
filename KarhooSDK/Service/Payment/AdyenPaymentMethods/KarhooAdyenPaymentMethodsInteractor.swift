//
//  KarhooAdyenPaymentMethodsInteractor.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAdyenPaymentMethodsInteractor: AdyenPaymentMethodsInteractor {
    private let adyenPaymentMethodsRequestSender: RequestSender

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.adyenPaymentMethodsRequestSender = requestSender
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        let payload = AdyenPaymentMethodsRequestPayload()
        adyenPaymentMethodsRequestSender.requestAndDecode(payload: payload,
                                                          endpoint: .adyenPaymentMethods,
                                                          callback: callback)
    }

    func cancel() {
        adyenPaymentMethodsRequestSender.cancelNetworkRequest()
    }
}
