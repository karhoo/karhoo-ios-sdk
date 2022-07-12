//
//  KarhooAdyenPaymentsDetailsInteractor.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 01/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAdyenPaymentsDetailsInteractor: AdyenPaymentsDetailsInteractor {
    
    private let adyenPaymentsDetailsRequestSender: RequestSender
    private let adyenApiVersionProvider: AdyenAPIVersionProvider
    private var paymentsDetails: PaymentsDetailsRequestPayload?
    
    init(
        requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
        adyenApiVersionProvider: AdyenAPIVersionProvider = KarhooAdyenAPIVersionProvider()
    ) {
        self.adyenPaymentsDetailsRequestSender = requestSender
        self.adyenApiVersionProvider = adyenApiVersionProvider
    }
    
    func set(paymentsDetails: PaymentsDetailsRequestPayload) {
        self.paymentsDetails = paymentsDetails
    }
    
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let dataCallback = callback as? CallbackClosure<DecodableData> else {
            return
        }

        adyenPaymentsDetailsRequestSender.request(
            payload: paymentsDetails,
            endpoint: .adyenPaymentsDetails(paymentAPIVersion: adyenApiVersionProvider.getVersion()),
            callback: { [weak self] result in
                self?.handle(result,
                             interactorCallback: dataCallback)
            })
    }
    
    func cancel() {
        adyenPaymentsDetailsRequestSender.cancelNetworkRequest()
    }

    private func handle(_ response: Result<HttpResponse>,
                        interactorCallback: CallbackClosure<DecodableData>) {
        switch response {
        case .failure(let error):
            interactorCallback(.failure(error: error.error))
        case .success(let response):
            interactorCallback(.success(result: DecodableData(data: response.result.data)))
        }
    }
}
