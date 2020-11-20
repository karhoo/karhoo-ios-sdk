//
//  KarhooGetProvider.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooPaymentProviderInteractor: PaymentProviderInteractor {
    
    private let paymentProviderRequestSender: RequestSender
    private let userDataStore: UserDataStore
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore()) {
        self.paymentProviderRequestSender = requestSender
        self.userDataStore = userDataStore
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        paymentProviderRequestSender.requestAndDecode(payload: nil,
                                                      endpoint: .paymentProvider,
                                                      callback: { [weak self] (result: Result<PaymentProvider>) in
                                                        self?.persistProvider(result)

                                                        guard let providerCallback = callback as? CallbackClosure<PaymentProvider> else {
                                                            callback(Result.failure(error: SDKErrorFactory.unexpectedError()))
                                                            return
                                                        }

                                                        providerCallback(result)
        })
    }

    func cancel() {
        paymentProviderRequestSender.cancelNetworkRequest()
    }

    private func persistProvider(_ result: Result<PaymentProvider>) {
        guard let paymentProvider = result.successValue() else {
            return
        }

        userDataStore.updatePaymentProvider(paymentProvider: paymentProvider)
    }
}
