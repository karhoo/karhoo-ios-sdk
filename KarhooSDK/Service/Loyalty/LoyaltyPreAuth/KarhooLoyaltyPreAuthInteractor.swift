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
    private var preAuthRequest: LoyaltyPreAuth?
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.requestSender = requestSender
    }
    
    func set(loyaltyPreAuth: LoyaltyPreAuth) {
        self.preAuthRequest = loyaltyPreAuth
    }
    
    func execute<T>(callback: @escaping CallbackClosure<T>) where T : KarhooCodableModel {
        guard let preAuthRequest = self.preAuthRequest else {
            let error = KarhooSDKError(code: "K0002", message: "Invalid request. Preauth failed.")
            callback(.failure(error: error))
            return 
        }
        
        let payload = LoyaltyPreAuthPayload(currency: preAuthRequest.currency, points: preAuthRequest.points, flexpay: preAuthRequest.flexpay, membership: preAuthRequest.membership)
        
        requestSender.request(payload: payload,
                              endpoint: endpoint(identifier: preAuthRequest.identifier),
                              callback: { result in
                                guard result.successValue(orErrorCallback: callback) != nil,
                                    let resultValue = LoyaltyNonce() as? T else { return }
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
