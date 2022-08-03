//
//  KarhooAuthLoginWithCredentialsInteractor.swift
//  KarhooSDK
//
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAuthLoginWithCredentialsInteractor: AuthLoginWithCredentialsInteractor {
    
    private var auth: AuthToken?
    private let userInfoSender: RequestSender
    private let userDataStore: UserDataStore
    private let analytics: AnalyticsService
    private let paymentProviderUpdateHandler: PaymentProviderUpdateHandler

    init(userInfoSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore(),
         analytics: AnalyticsService = KarhooAnalyticsService(),
         paymentProviderRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         loyaltyProviderRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         nonceRequestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         paymentProviderUpdateHandler: PaymentProviderUpdateHandler? = nil
    ) {
        self.userInfoSender = userInfoSender
        self.userDataStore = userDataStore
        self.analytics = analytics
        self.paymentProviderUpdateHandler = paymentProviderUpdateHandler ??
            KarhooPaymentProviderUpdateHandler(
                nonceRequestSender: nonceRequestSender,
                paymentProviderRequest: paymentProviderRequest,
                loyaltyProviderRequest: loyaltyProviderRequest
            )
    }

    func set(auth: AuthToken?) {
        self.auth = auth
    }
    
    func execute<T>(callback: @escaping CallbackClosure<T>) where T : KarhooCodableModel {
        guard let userInfoCallback = callback as? CallbackClosure<UserInfo> else {
            return
        }
        var credentials = userDataStore.getCurrentCredentials()
        
        if let value = auth {
            credentials = value.toCredentials()
        }
        
        if let credentials = credentials {
            self.userDataStore.set(credentials: credentials)
            self.getUserInfo(credentials: credentials, callback: userInfoCallback)
        } else {
            callback(.failure(error: SDKErrorFactory.unexpectedError()))
        }
    }
    
    private func getUserInfo(credentials: Credentials,
                             callback: @escaping CallbackClosure<UserInfo>) {
        userInfoSender.requestAndDecode(payload: nil,
                                        endpoint: .authUserInfo) { [weak self](result: Result<UserInfo>) in
                                            switch result {
                                            case .success(let user):
                                                self?.didLogin(user: user, credentials: credentials)
                                                callback(.success(result: user))
                                            case .failure(let error):
                                                callback(.failure(error: error))
                                            }
        }
    }
    
    func cancel() {
        userInfoSender.cancelNetworkRequest()
    }
    
    private func didLogin(user: UserInfo,
                          credentials: Credentials) {
        userDataStore.setCurrentUser(user: user, credentials: credentials)
        paymentProviderUpdateHandler.updatePaymentProvider(user: user)
        analytics.send(eventName: .ssoUserLogIn)
    }
}
