//
//  KarhooLoyaltyStatusInteractor.swift
//  KarhooSDK
//
//  Created by Edward Wilkins on 16/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooLoyaltyStatusInteractor: LoyaltyStatusInteractor {
    
    private let requestSender: RequestSender
    private var identifier: String?
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.requestSender = requestSender
    }
    
    func set(identifier: String) {
        self.identifier = identifier
    }
    
    func execute<T>(callback: @escaping CallbackClosure<T>) where T : KarhooCodableModel {
        requestSender.requestAndDecode(payload: nil,
                                       endpoint: .loyaltyStatus(identifier: identifier ?? ""),
                                       callback: callback)
    }
    
    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
