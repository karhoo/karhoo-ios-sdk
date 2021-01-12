//
//  KarhooSSOAuthInteractor.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAuthLoginInteractor: AuthLoginInteractor {
    
    private var token: String?
    private let tokenExchangeRequestSender: RequestSender
    private let userInfoSender: RequestSender
    private let userDataStore: UserDataStore
    private let analytics: AnalyticsService
    private let paymentProviderRequest: RequestSender

    init(tokenExchangeRequestSender: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         userInfoSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore(),
         analytics: AnalyticsService = KarhooAnalyticsService(),
         paymentProviderRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared)) {
        self.tokenExchangeRequestSender = tokenExchangeRequestSender
        self.userInfoSender = userInfoSender
        self.userDataStore = userDataStore
        self.analytics = analytics
        self.paymentProviderRequest = paymentProviderRequest
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
            self?.getUserInfo(authToken.toCredentials(), callback: userInfoCallback)
        })
    }

    private func getUserInfo(_ credentials: Credentials,
                             callback: @escaping CallbackClosure<UserInfo>) {
        userInfoSender.requestAndDecode(payload: nil,
                                        endpoint: .authUserInfo) { [weak self](result: Result<UserInfo>) in
                                            switch result {
                                            case .success(let user):
                                                self?.userDataStore.setCurrentUser(user: user, credentials: credentials)
                                                self?.updatePaymentProvider()
                                                self?.analytics.send(eventName: .ssoUserLogIn)
                                                callback(.success(result: user))
                                            case .failure(let error):
                                                callback(.failure(error: error))
                                            }
        }
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

    private func updatePaymentProvider() {
        paymentProviderRequest.requestAndDecode(payload: nil,
                                                endpoint: .paymentProvider,
                                                callback: { [weak self] (result: Result<PaymentProvider>) in
                                                    self?.userDataStore.updatePaymentProvider(paymentProvider: result.successValue())
                                                })
    }
}
