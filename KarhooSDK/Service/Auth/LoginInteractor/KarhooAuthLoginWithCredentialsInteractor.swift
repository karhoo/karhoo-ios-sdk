//
//  KarhooAuthLoginWithCredentialsInteractor.swift
//  KarhooSDK
//
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAuthLoginWithCredentialsInteractor: AuthLoginWithCredentialsInteractor {
    
    private var credentials: Credentials?
    private let credentialsRequestSender: RequestSender
    private let userInfoSender: RequestSender
    
    init(credentialsRequestSender: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         userInfoSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.credentialsRequestSender = credentialsRequestSender
        self.userInfoSender = userInfoSender
    }

    func set(credentials: Credentials?) {
        <#code#>
    }
    
    func execute<T>(callback: @escaping CallbackClosure<T>) where T : KarhooCodableModel {
        <#code#>
    }
    
    func cancel() {
        credentialsRequestSender.cancelNetworkRequest()
        userInfoSender.cancelNetworkRequest()
    }
    
}
