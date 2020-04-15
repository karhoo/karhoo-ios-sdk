//
//  KarhooGetNonceInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooGetNonceInteractor: GetNonceInteractor {

    private let getNonceRequest: RequestSender
    private var nonceRequestPayload: NonceRequestPayload?
    private let userDataStore: UserDataStore
    private var getNonceCallback: CallbackClosure<Nonce>?

    init(request: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore()) {
        self.getNonceRequest = request
        self.userDataStore = userDataStore
    }

    func set(nonceRequestPayload: NonceRequestPayload) {
        self.nonceRequestPayload = nonceRequestPayload
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let payload = self.nonceRequestPayload else {
            return
        }
    
        self.getNonceCallback = callback as? CallbackClosure<Nonce>
        getNonceRequest.requestAndDecode(payload: payload,
                                         endpoint: APIEndpoint.getNonce,
                                         callback: { [weak self] (result: Result<Nonce>) in
                                            self?.userDataStore.updateCurrentUserNonce(nonce: result.successValue())
                                            self?.getNonceCallback?(result)
        })
    }

    func cancel() {
        getNonceRequest.cancelNetworkRequest()
    }
}
