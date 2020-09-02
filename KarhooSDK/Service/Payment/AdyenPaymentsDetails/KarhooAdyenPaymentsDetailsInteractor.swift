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
    private var paymentsDetails: PaymentsDetailsRequestPayload?
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.adyenPaymentsDetailsRequestSender = requestSender
    }
    
    func set(paymentsDetails: PaymentsDetailsRequestPayload) {
        self.paymentsDetails = paymentsDetails
    }
    
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        adyenPaymentsDetailsRequestSender.requestAndDecode(payload: paymentsDetails,
                                                           endpoint: .adyenPaymentsDetails,
                                                           callback: callback)
    }
    
    func cancel() {
        adyenPaymentsDetailsRequestSender.cancelNetworkRequest()
    }
}
