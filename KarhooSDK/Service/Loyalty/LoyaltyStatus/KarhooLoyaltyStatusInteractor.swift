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
    private let userDataStore: UserDataStore
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore()) {
        self.requestSender = requestSender
        self.userDataStore = userDataStore
    }
    
    func set(identifier: String) {
        self.identifier = identifier
    }
    
    func execute<T>(callback: @escaping CallbackClosure<T>) where T : KarhooCodableModel {
        guard let identifier = identifier
        else {
            let error = KarhooSDKError(code: "K0002", message: "Invalid request. Missing loyalty identifier")
            callback(.failure(error: error))
            return
        }
        
        requestSender.requestAndDecode(payload: nil,
                                       endpoint: .loyaltyStatus(identifier: identifier),
                                       callback: { [weak self] (result: Result<T>) in
            if let statusResult = result as? Result<LoyaltyStatus>,
               let status = statusResult.successValue() {
                self?.userDataStore.updateLoyaltyStatus(status: status, forLoyaltyId: identifier)
            }
            
            callback(result)
        })
    }
    
    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
