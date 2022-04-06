//
//  KarhooAdyenPaymentMethodsInteractor.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAdyenPaymentMethodsInteractor: AdyenPaymentMethodsInteractor {

    private let adyenPaymentMethodsRequestSender: RequestSender
    private var paymentProviderAPIVersion: String?
    private var request: AdyenPaymentMethodsRequest?

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.adyenPaymentMethodsRequestSender = requestSender
    }

    func set(request: AdyenPaymentMethodsRequest) {
        self.request = request
    }

    func set(paymentProviderAPIVersion: String) {
        self.paymentProviderAPIVersion = "v68" // paymentProviderAPIVersion
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard
            let dataCallback = callback as? CallbackClosure<DecodableData>,
            let paymentProviderAPIVersion = paymentProviderAPIVersion
        else {
            return
        }

        adyenPaymentMethodsRequestSender.request(
            payload: request,
            endpoint: .adyenPaymentMethods(paymentAPIVersion: paymentProviderAPIVersion),
            callback: { [weak self] result in
                self?.handle(result, interactorCallback: dataCallback)
            })
    }

    func cancel() {
        adyenPaymentMethodsRequestSender.cancelNetworkRequest()
    }

    private func handle(_ response: Result<HttpResponse>, interactorCallback: CallbackClosure<DecodableData>) {
        switch response {
        case .failure(let error): interactorCallback(.failure(error: error))
        case .success(let response): interactorCallback(.success(result: DecodableData(data: response.data)))
        }
    }
}
