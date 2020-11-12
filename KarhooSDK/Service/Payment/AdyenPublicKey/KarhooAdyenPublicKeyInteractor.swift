//
//  KarhooAdyenPublicKeyInteractor.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 14/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAdyenPublicKeyInteractor: AdyenPublicKeyInteractor {
    
    private let adyenPublicKeyRequestSender: RequestSender
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.adyenPublicKeyRequestSender = requestSender
    }
    
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        adyenPublicKeyRequestSender.requestAndDecode(payload: nil, endpoint: .adyenPublicKey, callback: callback)
    }
    
    func cancel() {
        adyenPublicKeyRequestSender.cancelNetworkRequest()
    }
}
