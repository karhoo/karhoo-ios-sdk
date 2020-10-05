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
        adyenPaymentsRequestSender.request(payload: request,
                                                    endpoint: .adyenPayments,
                                                    callback: {  (result: Result<HttpResponse>) in
                                                        print("adyen payments interactor result: \(result)")
                                                    })
    }

    private func adyenResult(from result: Result<HttpResponse>) -> Result<AdyenPayments> {
        switch result {
        case .failure(let error): return .failure(error: error)
        case .success(let data):

            do {
                guard let json = try JSONSerialization.jsonObject(with: data.data, options: []) as? [String: Any] else {
                    return .failure(error: SDKErrorFactory.unexpectedError())
                }

                print("PAYMENTS! ", json)
                return .success(result: AdyenPayments())

            } catch let error {
                return .failure(error: SDKErrorFactory.unexpectedError())
            }
        }
    }
    
    func cancel() {
        adyenPaymentsRequestSender.cancelNetworkRequest()
    }
}
