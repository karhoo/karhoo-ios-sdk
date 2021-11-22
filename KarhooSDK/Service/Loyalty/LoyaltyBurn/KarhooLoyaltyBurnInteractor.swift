//
//  KarhooLoyaltyBurnInteractor.swift
//  KarhooSDK
//
//  Created by Edward Wilkins on 17/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooLoyaltyBurnInteractor: LoyaltyBurnInteractor {
    
    private let requestSender: RequestSender
    private var identifier: String?
    private var currency: String?
    private var amount: Int?
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.requestSender = requestSender
    }
    
    func set(identifier: String, currency: String, amount: Int) {
        self.identifier = identifier
        self.currency = currency
        self.amount = amount
    }
    
    func execute<T>(callback: @escaping CallbackClosure<T>) where T : KarhooCodableModel {
        guard let currency = self.currency else {
            return
        }
        
        requestSender.requestAndDecode(payload: nil,
                                       endpoint: .loyaltyBurn(identifier: identifier ?? "", currency: currency, amount: amount ?? 0),
                                       callback: callback)
    }
    
    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
