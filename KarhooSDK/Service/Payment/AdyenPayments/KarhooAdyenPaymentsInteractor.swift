//
//  KarhooAdyenPaymentsInteractor.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 25/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAdyenPaymentsInteractor: AdyenPaymentsInteractor {
    
    private let adyenPaymentsRequestSender: RequestSender
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.adyenPaymentsRequestSender = requestSender
    }
    
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        let payload = AdyenPaymentsRequestPayload()
        adyenPaymentsRequestSender.requestAndDecode(payload: payload, endpoint: .adyenPayments, callback: callback)
    }
    
    func cancel() {
        adyenPaymentsRequestSender.cancelNetworkRequest()
    }
}
