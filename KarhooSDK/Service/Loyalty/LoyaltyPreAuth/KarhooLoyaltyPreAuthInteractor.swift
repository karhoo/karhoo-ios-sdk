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
    
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let preAuthRequest = self.preAuthRequest else {
            let error = KarhooSDKError(code: "K0002", message: "Invalid request. Preauth failed.")
            callback(.failure(error: error))
            return 
        }
        
        let payload = LoyaltyPreAuthPayload(currency: preAuthRequest.currency,
                                            points: preAuthRequest.points,
                                            flexpay: preAuthRequest.flexpay,
                                            membership: preAuthRequest.membership)
        
        requestSender.requestAndDecode(payload: payload,
                                       endpoint: .loyaltyPreAuth(identifier: preAuthRequest.identifier),
                                       callback: callback)
    }
    
    func cancel() {
        requestSender.cancelNetworkRequest()
    }
    
    private func endpoint(identifier: String) -> APIEndpoint {
        return .loyaltyPreAuth(identifier: identifier)
    }
}
