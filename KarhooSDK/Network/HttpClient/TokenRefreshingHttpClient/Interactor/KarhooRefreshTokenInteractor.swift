//
//  RefreshTokenProvider.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooRefreshTokenInteractor: RefreshTokenInteractor {

    private let dataStore: UserDataStore
    private let refreshTokenRequest: RequestSender
    private var callback: ((Result<Bool>) -> Void)?

    init(dataStore: UserDataStore = DefaultUserDataStore(),
         refreshTokenRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared)) {
        self.dataStore = dataStore
        self.refreshTokenRequest = refreshTokenRequest
    }

    func tokenNeedsRefreshing() -> Bool {
        guard let credentials = dataStore.getCurrentCredentials() else {
            return false
        }
        return tokenNeedsRefreshing(credentials: credentials)
    }

    func refreshToken(completion: @escaping (Result<Bool>) -> Void) {
        self.callback = completion

        guard tokenNeedsRefreshing() else {
            completion(Result.success(result: false))
            return
        }

        guard let refreshToken = dataStore.getCurrentCredentials()?.refreshToken else {
            completion(Result.failure(error: RefreshTokenError.noRefreshToken))
            return
        }

        switch Karhoo.configuration.authenticationMethod() {
        case .guest:
            completion(Result.success(result: false))
        case .karhooUser:
            let refreshPayload = RefreshTokenRequestPayload(refreshToken: refreshToken)
            refreshTokenRequest.requestAndDecode(payload: refreshPayload,
                                                 endpoint: .karhooUserTokenRefresh,
                                                 callback: { [weak self] (result: Result<AuthToken>) in
                                                    self?.handleRefreshRequest(result: result)
            })
        case .tokenExchange:
            refreshTokenRequest.encodedRequest(endpoint: .authRefresh,
                                               body: authRefreshUrlComponents(),
                                               callback: { [weak self] (result: Result<AuthToken>) in
                                                self?.handleRefreshRequest(result: result)
            })
        }
    }

    private func authRefreshUrlComponents() -> URLComponents {
        var urlComponents = URLComponents()
        let tokenExchangeSettings = Karhoo.configuration.authenticationMethod().tokenExchangeSettings

        urlComponents.queryItems = [URLQueryItem(name: AuthHeaderKeys.clientId.rawValue, value: tokenExchangeSettings?.clientId ?? ""),
                                    URLQueryItem(name: AuthHeaderKeys.refreshToken.rawValue, value: dataStore.getCurrentCredentials()?.refreshToken ?? ""),
                                    URLQueryItem(name: AuthHeaderKeys.grantType.rawValue, value: AuthHeaderKeys.refreshToken.keyValue)]

        return urlComponents
    }

    private func handleRefreshRequest(result: Result<AuthToken>) {
        if let token = result.successValue() {
            guard self.tokenNeedsRefreshing() == true else {
                callback?(Result.success(result: false))
                return
            }

            self.saveToDataStore(token: token)

        } else if let error = result.errorValue() {
            callback?(Result.failure(error: error))
        }
    }

    private func saveToDataStore(token: AuthToken) {
        let currentCredentials = dataStore.getCurrentCredentials()
        let user = dataStore.getCurrentUser()
        let currentRefreshToken = currentCredentials?.refreshToken ?? ""
        let newCredentials = token.toCredentials(withRefreshToken: currentRefreshToken)

        if let user = user {
            dataStore.setCurrentUser(user: user, credentials: newCredentials)
            callback?(Result.success(result: true))
        } else {
            callback?(Result.failure(error: RefreshTokenError.userAlreadyLoggedOut))
        }
    }

    private func tokenNeedsRefreshing(credentials: Credentials) -> Bool {
        guard let expiryDate = credentials.expiryDate else {
            return true
        }

        let timeToExpiration = expiryDate.timeIntervalSince1970 - Date().timeIntervalSince1970
        return timeToExpiration < Constants.MaxTimeIntervalToRefreshToken
    }

    private struct Constants {
        static let MaxTimeIntervalToRefreshToken = TimeInterval(30) // 30 sec
    }
}
