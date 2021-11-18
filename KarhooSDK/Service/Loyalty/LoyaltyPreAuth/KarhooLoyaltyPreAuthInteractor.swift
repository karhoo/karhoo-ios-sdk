//
//  KarhooLoyaltyPreAuthInteractor.swift
//  KarhooSDK
//
//  Created by Edward Wilkins on 18/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooLoyaltyPreAuthInteractor: LoyaltyPreAuthInteractor {
    
    private let requestSender: RequestSender
    private var identifier: String?
    private var preAuthPayload: LoyaltyPreAuthPayload?
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.requestSender = requestSender
    }
    
    func set(loyaltyPreAuth: LoyaltyPreAuthPayload) {
        self.preAuthPayload = loyaltyPreAuth
    }
    
    func execute<T>(callback: @escaping CallbackClosure<T>) where T : KarhooCodableModel {
        guard let preAuthPayload = self.preAuthPayload else {
            return
        }
        
        let payload = LoyaltyPreAuthPayload(currency: preAuthPayload.currency, points: preAuthPayload.points, flexpay: preAuthPayload.flexpay, membership: preAuthPayload.membership)
        
        requestSender.request(payload: payload,
                              endpoint: endpoint(identifier: identifier ?? ""),
                              callback: { result in
                                guard result.successValue(orErrorCallback: callback) != nil,
                                    let resultValue = KarhooVoid() as? T else { return }
                                    callback(Result.success(result: resultValue))
        })
    }
    
    func cancel() {
        requestSender.cancelNetworkRequest()
    }
    
    private func endpoint(identifier: String) -> APIEndpoint {
        return .loyaltyPreAuth(identifier: identifier)
    }
}
