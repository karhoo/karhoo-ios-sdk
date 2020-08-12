//
//  KarhooAdyenPaymentMethodsInteractor.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAdyenPaymentMethodsInteractor: AdyenPaymentMethodsInteractor {
    private let adyenPaymentMethodsRequestSender: RequestSender
    private var adyenPaymentMethodsRequestPayload: AdyenPaymentMethodsRequestPayload?

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.adyenPaymentMethodsRequestSender = requestSender
    }
    
    func set(adyenPaymentMethodsRequestPayload: AdyenPaymentMethodsRequestPayload) {
        self.adyenPaymentMethodsRequestPayload = adyenPaymentMethodsRequestPayload
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let payload = self.adyenPaymentMethodsRequestPayload else { return }
        adyenPaymentMethodsRequestSender.requestAndDecode(payload: payload,
                                                          endpoint: .adyenPaymentMethods,
                                                          callback: callback)
    }

    func cancel() {
        adyenPaymentMethodsRequestSender.cancelNetworkRequest()
    }
}
