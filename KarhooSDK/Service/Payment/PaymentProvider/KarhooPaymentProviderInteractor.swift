//
//  KarhooGetProvider.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooPaymentProviderInteractor: PaymentProviderInteractor {
    
    private let paymentProviderRequestSender: RequestSender

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.paymentProviderRequestSender = requestSender
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        paymentProviderRequestSender.requestAndDecode(payload: nil,
                                                      endpoint: .paymentProvider,
                                                      callback: callback)
    }

    func cancel() {
        paymentProviderRequestSender.cancelNetworkRequest()
    }
}
