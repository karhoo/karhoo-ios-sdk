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
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.adyenPaymentsDetailsRequestSender = requestSender
    }
    
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        let payload = AdyenPaymentsRequestPayload()
        adyenPaymentsDetailsRequestSender.requestAndDecode(payload: payload, endpoint: .adyenPayments, callback: callback)
    }
    
    func cancel() {
        adyenPaymentsDetailsRequestSender.cancelNetworkRequest()
    }
}
