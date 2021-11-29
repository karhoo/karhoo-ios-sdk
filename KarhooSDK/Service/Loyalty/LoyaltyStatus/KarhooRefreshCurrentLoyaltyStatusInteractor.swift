//
//  KarhooRefreshLoyaltyStatusInteractor.swift
//  KarhooSDK
//
//  Created by Diana Petrea on 29.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooRefreshCurrentLoyaltyStatusInteractor: RefreshCurrentLoyaltyStatusInteractor {
    
    private let requestSender: RequestSender
    private let userDataStore: UserDataStore
    private var identifier: String?
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore()) {
        self.requestSender = requestSender
        self.userDataStore = userDataStore
    }
    
    func set(identifier: String) {
        self.identifier = identifier
    }
    
    func execute<T>(callback: @escaping CallbackClosure<T>) where T : KarhooCodableModel {
        requestSender.requestAndDecode(payload: nil,
                                       endpoint: .loyaltyStatus(identifier: identifier ?? ""),
                                       callback: { [weak self] (result: Result<T>) in
            if let statusResult = result as? Result<LoyaltyStatus>,
               let status = statusResult.successValue() {
                self?.userDataStore.updateLoyaltyStatus(status: status)
            }
            
            callback(result)
        })
    }
    
    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
