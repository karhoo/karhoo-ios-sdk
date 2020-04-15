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
    
    init(tokenExchangeRequestSender: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         userInfoSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore(),
         analytics: AnalyticsService = KarhooAnalyticsService()) {
        self.tokenExchangeRequestSender = tokenExchangeRequestSender
        self.userInfoSender = userInfoSender
        self.userDataStore = userDataStore
        self.analytics = analytics
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
            self?.userDataStore.set(credentials: authToken.toCredentials())
            self?.getUserInfo(authToken.accessToken, callback: userInfoCallback)
        })
    }

    private func getUserInfo(_ token: String, callback: @escaping CallbackClosure<UserInfo>) {
        userInfoSender.requestAndDecode(payload: nil,
                                        endpoint: .authUserInfo) { [weak self](result: Result<UserInfo>) in
                                            switch result {
                                            case .success(var user):
                                                self?.userDataStore.updateUser(user: &user)
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
}
