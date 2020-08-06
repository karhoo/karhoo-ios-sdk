//
//  KarhooGetProvider.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooPaymentProviderInteractor: PaymentProviderInteractor {
    
    private let paymentProviderRequestSender: RequestSender
    private var paymentProviderCallback: CallbackClosure<PaymentProvider>?

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.paymentProviderRequestSender = requestSender
    }

    func execute<T>(callback: @escaping (Result<T>) -> Void) where T: KarhooCodableModel {
        paymentProviderRequestSender.requestAndDecode(payload: nil,
                                                      endpoint: .paymentProvider,
                                                      callback: callback)
    }

    func cancel() {
        paymentProviderRequestSender.cancelNetworkRequest()
    }
}
