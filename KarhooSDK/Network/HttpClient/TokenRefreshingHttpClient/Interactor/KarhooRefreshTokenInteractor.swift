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
        callback = completion

        guard tokenNeedsRefreshing() else {
            completion(Result.success(result: false))
            return
        }

        guard let refreshToken = dataStore.getCurrentCredentials()?.refreshToken,
                refreshToken.isEmpty == false,
                refreshTokenNeedsRefreshing(credentials: dataStore.getCurrentCredentials()) == false
        else {
            requestExteralAuthentication()
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
    
    private func requestExteralAuthentication() {
        Karhoo.configuration.requireSDKAuthentication { [weak self] in
            guard let self = self else {
                // Self not accessible so no way to call callback
                assertionFailure()
                return
            }
            if let newCredentials = self.dataStore.getCurrentCredentials() {
                let newToken = AuthToken(
                    accessToken: newCredentials.accessToken,
                    expiresIn: Int(newCredentials.expiryDate?.timeIntervalSinceNow ?? 0),
                    refreshToken: newCredentials.refreshToken ?? "",
                    refreshExpiresIn: Int(newCredentials.refreshTokenExpiryDate?.timeIntervalSinceNow ?? 0)
                )
                // The request completion will be called inside `handleRefreshRequest` method.
                self.handleRefreshRequest(result: .success(result: newToken))
            } else {
                self.callback?(Result.failure(error: RefreshTokenError.noAccessToken))
            }
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
        guard tokenNeedsRefreshing() else {
            callback?(Result.success(result: false))
            return
        }
        
        switch result {
        case .success(result: let token, _):
            saveToDataStore(token: token)
        case .failure:
            requestExteralAuthentication()
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
        checkDateDueTime(for: credentials.expiryDate)
    }
    
    private func refreshTokenNeedsRefreshing(credentials: Credentials?) -> Bool {
        guard let credentials = credentials else {
            return true
        }
        return checkDateDueTime(for: credentials.refreshTokenExpiryDate)
    }
    
    // Check if expire date for refresh token or token makes it needs to be renewed
    private func checkDateDueTime(for date: Date?) -> Bool {
        guard let date = date else {
            return true
        }
        let timeToExpiration = date.timeIntervalSince1970 - Date().timeIntervalSince1970
        return timeToExpiration < Constants.MaxTimeIntervalToRefreshToken
    }

    private struct Constants {
        static let MaxTimeIntervalToRefreshToken = TimeInterval(30) // 30 sec
    }
}
