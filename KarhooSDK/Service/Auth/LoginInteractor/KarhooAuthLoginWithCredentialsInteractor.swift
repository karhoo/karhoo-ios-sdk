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
    private let userDataStore: UserDataStore
    private let analytics: AnalyticsService
    private let paymentProviderRequest: RequestSender
    private let nonceRequestSender: RequestSender
    
    init(credentialsRequestSender: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         userInfoSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore(),
         analytics: AnalyticsService = KarhooAnalyticsService(),
         paymentProviderRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         nonceRequestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.credentialsRequestSender = credentialsRequestSender
        self.userInfoSender = userInfoSender
        self.userDataStore = userDataStore
        self.analytics = analytics
        self.paymentProviderRequest = paymentProviderRequest
        self.nonceRequestSender = nonceRequestSender
    }

    func set(credentials: Credentials?) {
        self.credentials = credentials
    }
    
    func execute<T>(callback: @escaping CallbackClosure<T>) where T : KarhooCodableModel {
        if credentials == nil { return }
        guard let userInfoCallback = callback as? CallbackClosure<UserInfo> else {
            return
        }
        //TODO: Figuring how how to sort this
    }
    
    func cancel() {
        credentialsRequestSender.cancelNetworkRequest()
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
                                                    if paymentProvider?.provider.type == .braintree {
                                                        self?.updateUserNonce(user: user)
                                                    }
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
