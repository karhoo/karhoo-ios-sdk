//
//  RefreshTokenProvider.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooRefreshTokenInteractor: RefreshTokenInteractor {

    // MARK: - Nested types

    private enum Constants {
        static let refreshBuffer: TimeInterval = 5 * 60 // Seconds buffer when refresh token should be refreshed proactively, so it never becomes expired
        static let allowedExternalAuthTimeInterval: TimeInterval = 60
    }

    // MARK: - Properties

    private var externalAuthInvalidationTimer: Timer?
    private var refreshTokenTimer: Timer?
    private let dataStore: UserDataStore
    private let refreshTokenRequest: RequestSender
    private var callback: ((Result<Bool>) -> Void)?

    // MARK: - Lifecycle

    init(dataStore: UserDataStore = DefaultUserDataStore(),
         refreshTokenRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared)) {
        self.dataStore = dataStore
        self.refreshTokenRequest = refreshTokenRequest
    }

    deinit {
        invalidateRefreshTokenTimer()
        invalidateExternalAuthTimer()
    }

    // MARK: - Endpoint methods

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
    
    // MARK: - Private methods

    private func requestExteralAuthentication() {
        scheduleExtenalAuthInvalidationTimer()
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
            scheduleRefreshTokenTimer()
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
        return timeToExpiration < Constants.refreshBuffer
    }

    // MARK: Timers scheduling

    private func scheduleRefreshTokenTimer() {
        guard let credentials = dataStore.getCurrentCredentials() else {
            assertionFailure("Credentials should be set at this stage")
            return
        }
        invalidateRefreshTokenTimer()

        let secondsToRefresh: TimeInterval = max(0, (credentials.expiryDate?.timeIntervalSinceNow ?? 0) - Constants.refreshBuffer)

        refreshTokenTimer = Timer.scheduledTimer(
            withTimeInterval: secondsToRefresh,
            repeats: false,
            block: { [weak self] _ in
                self?.refreshToken { result in
                    print("KarhooRefreshTokenInteractor.proactivelyRefreshToken result: \(result)")
                }
            }
        )
        RunLoop.main.add(refreshTokenTimer!, forMode: .common)
    }

    /// Schedule a timer that will return extenal authentition error if given time interval will be reached. This is designed as fallback in case of invalid DPs implementation of the `requireSDKAuthentication` method.
    private func scheduleExtenalAuthInvalidationTimer() {
        invalidateExternalAuthTimer()
        externalAuthInvalidationTimer = Timer.scheduledTimer(
            withTimeInterval: Constants.allowedExternalAuthTimeInterval,
            repeats: false,
            block: { [weak self] _ in
                guard let self else { return }
                self.invalidateExternalAuthTimer()
                self.callback?(.failure(error: RefreshTokenError.extenalAuthenticationRequestExpired))
            }
        )
        RunLoop.main.add(externalAuthInvalidationTimer!, forMode: .common)
    }

    // MARK: - Utils
    
    private func invalidateRefreshTokenTimer() {
        refreshTokenTimer?.invalidate()
        refreshTokenTimer = nil
    }

    private func invalidateExternalAuthTimer() {
        externalAuthInvalidationTimer?.invalidate()
        externalAuthInvalidationTimer = nil
    }

}
