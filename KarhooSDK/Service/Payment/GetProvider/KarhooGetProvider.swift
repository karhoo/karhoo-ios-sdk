//
//  KarhooGetProvider.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooGetProviderInteractor: GetProviderInteractor {
    
    private let getProviderRequest: RequestSender
//    TODO ProviderRequeustPayload?
    private var getProviderCallback: CallbackClosure<Provider>?

    init(request: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore()) {
        self.getProviderRequest = request
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
    
        self.getProviderCallback = callback as? CallbackClosure<Provider>
        getProviderRequest.requestAndDecode(payload: nil,
                                         endpoint: APIEndpoint.provider,
                                         callback: { [weak self] (result: Result<Provider>) in
                                            self?.getProviderCallback?(result)
        })
    }

    func cancel() {
        getProviderRequest.cancelNetworkRequest()
    }
}
