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
        static let allowedExternalAuthTimeInterval: TimeInterval = 60
    }

    // MARK: - Properties

    private let tokenValidityWorker: TokenValidityWorker
    private var externalAuthInvalidationTimer: Timer?
    private var refreshTokenTimer: Timer?
    private let dataStore: UserDataStore
    private let refreshTokenRequest: RequestSender

    private var isTokenRefreshInProgress = false
    private var isExternalAuthRequestInProgress = false
    private var completionWaitingForTokenRefresh: [(Result<Bool>) -> Void] = []

    // MARK: - Lifecycle

    init(
        dataStore: UserDataStore = DefaultUserDataStore(),
        refreshTokenRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
        tokenValidityWorker: TokenValidityWorker = KarhooTokenValidityWorker()
    ) {
        self.dataStore = dataStore
        self.refreshTokenRequest = refreshTokenRequest
        self.tokenValidityWorker = tokenValidityWorker
    }

    deinit {
        invalidateRefreshTokenTimer()
        invalidateExternalAuthTimer()
    }

    // MARK: - Endpoint methods

    func tokenNeedsRefreshing() -> Bool {
        tokenValidityWorker.tokenNeedsRefreshing()
    }

    func refreshToken(completion: @escaping (Result<Bool>) -> Void) {
        completionWaitingForTokenRefresh.append(completion)

        guard isTokenRefreshInProgress == false else {
            // Refresh in progress, completion will be evaluated once the process is done.
            return
        }
        guard tokenNeedsRefreshing() else {
            resolveRefreshCompletions(using: .success(result: false))
            return
        }

        guard let refreshToken = dataStore.getCurrentCredentials()?.refreshToken,
                refreshToken.isEmpty == false,
                refreshTokenNeedsRefreshing() == false
        else {
            requestExternalAuthentication()
            return
        }

        switch Karhoo.configuration.authenticationMethod() {
        case .guest:
            resolveRefreshCompletions(using: .success(result: false))
        case .tokenExchange:
            refreshTokenRequest.encodedRequest(endpoint: .authRefresh,
                                               body: authRefreshUrlComponents(),
                                               callback: { [weak self] (result: Result<AuthToken>) in
                                                self?.handleRefreshRequest(result: result)
            })
        }
    }
    
    // MARK: - Private methods

    private func requestExternalAuthentication() {
        guard isExternalAuthRequestInProgress == false else {
            return
        }
        isExternalAuthRequestInProgress = true
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
                self.resolveRefreshCompletions(using: .failure(error: RefreshTokenError.noAccessToken))
            }
            self.isExternalAuthRequestInProgress = false
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
            resolveRefreshCompletions(using: .success(result: false))
            return
        }
        
        switch result {
        case .success(result: let token, _):
            tokenValidityWorker.saveRefreshBuffer(token: token)
            saveToDataStore(token: token)
        case .failure:
            requestExternalAuthentication()
        }
    }

    private func saveToDataStore(token: AuthToken) {
        let currentCredentials = dataStore.getCurrentCredentials()
        let user = dataStore.getCurrentUser()
        let currentRefreshToken = currentCredentials?.refreshToken ?? ""
        let newCredentials = token.toCredentials(withRefreshToken: currentRefreshToken)

        if let user = user {
            dataStore.setCurrentUser(user: user, credentials: newCredentials)
            resolveRefreshCompletions(using: .success(result: true))
            scheduleRefreshTokenTimer()
        } else {
            resolveRefreshCompletions(using: .failure(error: RefreshTokenError.userAlreadyLoggedOut))
        }
    }

    // MARK: Completion resolvment

    private func resolveRefreshCompletions(using result: Result<Bool>) {
        DispatchQueue.main.async {
            self.completionWaitingForTokenRefresh.forEach { completion in
                completion(result)
            }
            self.completionWaitingForTokenRefresh = []
        }
    }

    // MARK: Timers scheduling

    private func scheduleRefreshTokenTimer() {
        invalidateRefreshTokenTimer()

        refreshTokenTimer = Timer.scheduledTimer(
            withTimeInterval: tokenValidityWorker.timeToRequiredRefresh(),
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
                self.isExternalAuthRequestInProgress = false
                self.invalidateExternalAuthTimer()
                self.resolveRefreshCompletions(using: .failure(error: RefreshTokenError.extenalAuthenticationRequestExpired))
            }
        )
        RunLoop.main.add(externalAuthInvalidationTimer!, forMode: .common)
    }

    // MARK: - Utils

    private func refreshTokenNeedsRefreshing() -> Bool {
        tokenValidityWorker.refreshTokenNeedsRefreshing()
    }

    private func invalidateRefreshTokenTimer() {
        refreshTokenTimer?.invalidate()
        refreshTokenTimer = nil
    }

    private func invalidateExternalAuthTimer() {
        externalAuthInvalidationTimer?.invalidate()
        externalAuthInvalidationTimer = nil
    }

}
