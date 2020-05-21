//
//  KarhoooSSOAuthRevokeInteractor.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhoooAuthRevokeInteractor: KarhooExecutable {
    
    private let userDataStore: UserDataStore
    private let revokeRequestSender: RequestSender
    private let analytics: AnalyticsService

    init(userDataStore: UserDataStore = DefaultUserDataStore(),
         revokeRequestSender: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         analytics: AnalyticsService = KarhooAnalyticsService()) {
        self.userDataStore = userDataStore
        self.revokeRequestSender = revokeRequestSender
        self.analytics = analytics
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard userDataStore.getCurrentUser() != nil else {
            callback(Result.failure(error: nil))
            return
        }

        revokeRequestSender.encodedRequest(endpoint: .authRevoke,
                                           body: requestComponents(),
                                           callback: { [weak self] (result: Result<KarhooVoid>) in
                                            guard result.successValue(orErrorCallback: callback) != nil,
                                                let resultValue = KarhooVoid() as? T else { return }
                                            self?.analytics.send(eventName: .ssoTokenRevoked)
                                            self?.userDataStore.removeCurrentUserAndCredentials()
                                            callback(Result.success(result: resultValue))
        })
    }

    private func requestComponents() -> URLComponents {
        var urlComponents = URLComponents()
        let tokenExchangeSettings = Karhoo.configuration.authenticationMethod().tokenExchangeSettings

        urlComponents.queryItems = [URLQueryItem(name: AuthHeaderKeys.token.rawValue, value: userDataStore.getCurrentCredentials()?.refreshToken ?? ""),
                                    URLQueryItem(name: AuthHeaderKeys.tokenTypeHint.rawValue, value: AuthHeaderKeys.refreshToken.keyValue),
                                    URLQueryItem(name: AuthHeaderKeys.clientId.rawValue, value: tokenExchangeSettings?.clientId ?? "")]

        return urlComponents
    }

    func cancel() {
        revokeRequestSender.cancelNetworkRequest()
    }
}
