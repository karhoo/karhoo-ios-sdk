//
//  KarhooSSOAuthInteractor.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAuthLoginWithTokenInteractor: AuthLoginWithTokenInteractor {
    
    private var token: String?
    private let tokenExchangeRequestSender: RequestSender
    private let userInfoSender: RequestSender
    private let userDataStore: UserDataStore
    private let analytics: AnalyticsService
    private let paymentProviderRequest: RequestSender
    private let loyaltyProviderRequest: RequestSender
    private let nonceRequestSender: RequestSender

    init(tokenExchangeRequestSender: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         userInfoSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore(),
         analytics: AnalyticsService = KarhooAnalyticsService(),
         paymentProviderRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         loyaltyProviderRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         nonceRequestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.tokenExchangeRequestSender = tokenExchangeRequestSender
        self.userInfoSender = userInfoSender
        self.userDataStore = userDataStore
        self.analytics = analytics
        self.paymentProviderRequest = paymentProviderRequest
        self.loyaltyProviderRequest = loyaltyProviderRequest
        self.nonceRequestSender = nonceRequestSender
    }
    
    func cancel() {
        tokenExchangeRequestSender.cancelNetworkRequest()
        userInfoSender.cancelNetworkRequest()
    }
    
    func set(token: String) {
        self.token = token
    }
    
   func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        if token == nil { return }
        guard let userInfoCallback = callback as? CallbackClosure<UserInfo> else {
            return
        }

        tokenExchangeRequestSender.encodedRequest(endpoint: .authTokenExchange,
                                                  body: authLoginHeaderComponents(),
                                                  callback: { [weak self] (result: Result<AuthToken>) in
            guard let authToken = result.successValue() else {
                userInfoCallback(.failure(error: result.errorValue()))
                return
            }
            let credentials = authToken.toCredentials()
            self?.userDataStore.set(credentials: credentials)
                                                    self?.getUserInfo(credentials: credentials, callback: userInfoCallback)
        })
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
    
    private func didLogin(user: UserInfo,
                          credentials: Credentials) {
        userDataStore.setCurrentUser(user: user, credentials: credentials)
        updatePaymentProvider(user: user)
        analytics.send(eventName: .ssoUserLogIn)
    }
    
    private func authLoginHeaderComponents() -> URLComponents {
        var components = URLComponents()
        let tokenExchangeSettings = Karhoo.configuration.authenticationMethod().tokenExchangeSettings

        components.queryItems = [URLQueryItem(name: AuthHeaderKeys.scope.rawValue,
                                              value: tokenExchangeSettings?.scope ?? ""),
                                 URLQueryItem(name: AuthHeaderKeys.clientId.rawValue,
                                              value: tokenExchangeSettings?.clientId ?? ""),
                                 URLQueryItem(name: AuthHeaderKeys.token.rawValue, value: token)]
        return components
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
