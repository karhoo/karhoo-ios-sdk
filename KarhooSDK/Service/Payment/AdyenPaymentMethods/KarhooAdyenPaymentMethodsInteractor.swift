//
//  KarhooAdyenPaymentMethodsInteractor.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAdyenPaymentMethodsInteractor: AdyenPaymentMethodsInteractor {

    private let adyenPaymentMethodsRequestSender: RequestSender
    private let adyenApiVersionProvider: AdyenAPIVersionProvider
    private var request: AdyenPaymentMethodsRequest?

    init(
        requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
        adyenApiVersionProvider: AdyenAPIVersionProvider = KarhooAdyenAPIVersionProvider()
    ) {
        self.adyenPaymentMethodsRequestSender = requestSender
        self.adyenApiVersionProvider = adyenApiVersionProvider
    }

    func set(request: AdyenPaymentMethodsRequest) {
        self.request = request
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard
            let dataCallback = callback as? CallbackClosure<DecodableData>
        else {
            return
        }

        adyenPaymentMethodsRequestSender.request(
            payload: request,
            endpoint: .adyenPaymentMethods(paymentAPIVersion: adyenApiVersionProvider.getVersion()),
            callback: { [weak self] result in
                self?.handle(result, interactorCallback: dataCallback)
            })
    }

    func cancel() {
        adyenPaymentMethodsRequestSender.cancelNetworkRequest()
    }

    private func handle(_ response: Result<HttpResponse>, interactorCallback: CallbackClosure<DecodableData>) {
        switch response {
        case .failure(let error, _): interactorCallback(.failure(error: error))
        case .success(let result, _): interactorCallback(.success(result: DecodableData(data: result.data)))
        }
    }
}
