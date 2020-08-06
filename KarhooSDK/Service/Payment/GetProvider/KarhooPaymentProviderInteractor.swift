//
//  KarhooGetProvider.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooPaymentProviderInteractor: PaymentProviderInteractor {
    
    private let paymentProviderRequest: RequestSender
//    TODO ProviderRequeustPayload?
    private var paymentProviderCallback: CallbackClosure<PaymentProvider>?

    init(request: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore()) {
        self.paymentProviderRequest = request
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
    
        self.paymentProviderCallback = callback as? CallbackClosure<PaymentProvider>
        paymentProviderRequest.requestAndDecode(payload: nil,
                                         endpoint: APIEndpoint.provider,
                                         callback: { [weak self] (result: Result<PaymentProvider>) in
                                            self?.paymentProviderCallback?(result)
        })
    }

    func cancel() {
        paymentProviderRequest.cancelNetworkRequest()
    }
}
