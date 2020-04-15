//
//  KarhooAddPaymentDetailsInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooAddPaymentDetailsInteractor: AddPaymentDetailsInteractor {

    private var addPaymentDetailsPayload: AddPaymentDetailsPayload?
    private let requestSender: RequestSender
    private let userDataStore: UserDataStore
    private var executeCallback: CallbackClosure<Nonce>?

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore()) {
        self.requestSender = requestSender
        self.userDataStore = userDataStore
    }

    func set(addPaymentDetailsPayload: AddPaymentDetailsPayload) {
        self.addPaymentDetailsPayload = addPaymentDetailsPayload
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let payload = self.addPaymentDetailsPayload else {
            return
        }
        self.executeCallback = callback as? CallbackClosure<Nonce>

        requestSender.requestAndDecode(payload: payload,
                                       endpoint: APIEndpoint.addPaymentDetails,
                                       callback: {  [weak self] (result: Result<Nonce>) in
                                        if let nonce = result.successValue() {
                                            self?.userDataStore.updateCurrentUserNonce(nonce: nonce)
                                        }

                                        self?.executeCallback?(result)

        })
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
