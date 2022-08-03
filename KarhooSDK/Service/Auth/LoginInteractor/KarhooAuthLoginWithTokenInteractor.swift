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
    private let nonceRequestSender: RequestSender
    private let paymentProviderRequest: RequestSender
    private let userDataStore: UserDataStore
    private let analytics: AnalyticsService
    private let paymentProviderUpdateHandler: PaymentProviderUpdateHandler

    init(tokenExchangeRequestSender: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         userInfoSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         paymentProviderRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         nonceRequestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         loyaltyProviderRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore(),
         analytics: AnalyticsService = KarhooAnalyticsService(),
         paymentProviderUpdateHandler: PaymentProviderUpdateHandler? = nil
    ) {
        self.tokenExchangeRequestSender = tokenExchangeRequestSender
        self.userInfoSender = userInfoSender
        self.paymentProviderRequest = paymentProviderRequest
        self.nonceRequestSender = nonceRequestSender
        self.userDataStore = userDataStore
        self.analytics = analytics
        self.paymentProviderUpdateHandler = paymentProviderUpdateHandler ??
            KarhooPaymentProviderUpdateHandler(
                nonceRequestSender: nonceRequestSender,
                paymentProviderRequest: paymentProviderRequest,
                loyaltyProviderRequest: loyaltyProviderRequest
            )
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
        paymentProviderUpdateHandler.updatePaymentProvider(user: user)
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
}
