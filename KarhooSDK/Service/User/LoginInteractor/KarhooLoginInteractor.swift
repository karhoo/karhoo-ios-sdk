//
//  KarhooLoginInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooLoginInteractor: LoginInteractor {

    private var userLogin: UserLogin?

    private let analytics: AnalyticsService
    private let loginRequestSender: RequestSender
    private let profileRequestSender: RequestSender
    private let nonceRequestSender: RequestSender
    private let paymentProviderRequest: RequestSender
    private let userDataStore: UserDataStore
    private let authorizedUserRoles = ["TRIP_ADMIN", "MOBILE_USER"]
    private let paymentProviderUpdateHandler: PaymentProviderUpdateHandler
    

    init(userDataStore: UserDataStore = DefaultUserDataStore(),
         loginRequestSender: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared),
         profileRequestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         analytics: AnalyticsService = KarhooAnalyticsService(),
         nonceRequestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         paymentProviderRequest: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         loyaltyProviderRequest: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         paymentProviderUpdateHandler: PaymentProviderUpdateHandler? = nil
    ) {
        self.analytics = analytics
        self.userDataStore = userDataStore
        self.loginRequestSender = loginRequestSender
        self.profileRequestSender = profileRequestSender
        self.nonceRequestSender = nonceRequestSender
        self.paymentProviderRequest = paymentProviderRequest
        self.paymentProviderUpdateHandler = paymentProviderUpdateHandler ??
            KarhooPaymentProviderUpdateHandler(
                nonceRequestSender: nonceRequestSender,
                paymentProviderRequest: paymentProviderRequest,
                loyaltyProviderRequest: loyaltyProviderRequest
            )
    }

    func set(userLogin: UserLogin) {
        self.userLogin = userLogin
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let userLogin = self.userLogin else {
            return
        }

        if let user = userDataStore.getCurrentUser(),
            let result = user as? T {
            if user.email == userLogin.username {
                callback(Result.success(result: result))
                return
            }
            callback(Result.failure(error: SDKErrorFactory.userAlreadyLoggedIn()))
            return
        }

        loginRequestSender.requestAndDecode(payload: userLogin,
                                            endpoint: .login,
                                            callback: { [weak self] (result: Result<AuthToken>) in
                                                guard let token = result.successValue(
                                                    orErrorCallback: callback) else { return }
                                                self?.gotToken(token: token, callback: callback)
        })
    }

    func cancel() {
        loginRequestSender.cancelNetworkRequest()
        profileRequestSender.cancelNetworkRequest()
    }

    private func gotToken<T: KarhooCodableModel>(token: AuthToken,
                                                 callback: @escaping CallbackClosure<T>) {
        let credentials = token.toCredentials()
        userDataStore.set(credentials: credentials)
        sendProfileRequest(callback: callback, credentials: credentials)
    }

    private func sendProfileRequest<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>,
                                                           credentials: Credentials?) {
        profileRequestSender.requestAndDecode(payload: nil,
                                              endpoint: .userProfile,
                                              callback: {[weak self] (result: Result<UserInfo>) in
                                                    guard let user = result.successValue(orErrorCallback: callback)
                                                    else {
                                                        return
                                                    }
                                                    self?.handleProfileRequest(user: user,
                                                                               callback: callback,
                                                                               credentials: credentials)
        })
    }

    private func handleProfileRequest<T: KarhooCodableModel>(user: UserInfo,
                                                             callback: @escaping CallbackClosure<T>,
                                                             credentials: Credentials?) {
        if userIsAuthorized(user: user) {
            didLogin(user: user, callback: callback, credentials: credentials)
        } else {
            callback(.failure(error: SDKErrorFactory.getLoginPermissionError()))
        }
    }

    private func userIsAuthorized(user: UserInfo) -> Bool {
        return user.organisations.flatMap { $0.roles }.contains(where: { authorizedUserRoles.contains($0) })
    }

    private func didLogin<T: KarhooCodableModel>(user: UserInfo,
                                                 callback: CallbackClosure<T>,
                                                 credentials: Credentials?) {
        guard let credentials = credentials else {
            callback(.failure(error: SDKErrorFactory.unexpectedError()))
            return
        }

        guard let result = user as? T else {
            return
        }

        analytics.send(eventName: .userLoggedIn)
        userDataStore.setCurrentUser(user: user, credentials: credentials)
        paymentProviderUpdateHandler.updatePaymentProvider(user: user)
        callback(.success(result: result))
    }
}
