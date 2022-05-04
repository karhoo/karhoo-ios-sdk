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
    private let paymentProviderRequest: RequestSender
    private let loyaltyProviderRequest: RequestSender
    private let nonceRequestSender: RequestSender
    
    init(userInfoSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore(),
         analytics: AnalyticsService = KarhooAnalyticsService(),
         paymentProviderRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         loyaltyProviderRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         nonceRequestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.userInfoSender = userInfoSender
        self.userDataStore = userDataStore
        self.analytics = analytics
        self.paymentProviderRequest = paymentProviderRequest
        self.nonceRequestSender = nonceRequestSender
        self.loyaltyProviderRequest = loyaltyProviderRequest
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
        updatePaymentProvider(user: user)
        analytics.send(eventName: .ssoUserLogIn)
    }

    private func updatePaymentProvider(user: UserInfo) {
        paymentProviderRequest.requestAndDecode(payload: nil,
                                                endpoint: .paymentProvider,
                                                callback: { [weak self] (result: Result<PaymentProvider>) in
            let paymentProvider = result.successValue()
            self?.userDataStore.updatePaymentProvider(paymentProvider: paymentProvider)
//            if paymentProvider?.provider.type == .braintree {
                self?.updateUserNonce(user: user)
//            }
            
            guard let self = self else { return }
            LoyaltyUtils.updateLoyaltyStatusFor(paymentProvider: paymentProvider,
                                                userDataStore: self.userDataStore,
                                                loyaltyProviderRequest: self.loyaltyProviderRequest)
        })
    }
    
    private func updateUserNonce(user: UserInfo) {
        let payload = NonceRequestPayload(payer: Payer(user: user),
                                          organisationId: user.organisations.first?.id ?? "")

        nonceRequestSender.requestAndDecode(payload: payload,
                                            endpoint: .getNonce) { [weak self] (result: Result<Nonce>) in
                                                self?.userDataStore.updateCurrentUserNonce(nonce: result.successValue())
        }
    }
}
