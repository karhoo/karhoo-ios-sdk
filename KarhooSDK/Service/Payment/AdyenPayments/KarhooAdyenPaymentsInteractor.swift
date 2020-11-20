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
    private var request: AdyenPaymentsRequest?

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.adyenPaymentsRequestSender = requestSender
    }

    func set(request: AdyenPaymentsRequest) {
        self.request = request
    }
    
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        adyenPaymentsRequestSender.requestAndDecode(payload: request, endpoint: .adyenPayments, callback: callback)
    }

    func cancel() {
        adyenPaymentsRequestSender.cancelNetworkRequest()
    }
}
