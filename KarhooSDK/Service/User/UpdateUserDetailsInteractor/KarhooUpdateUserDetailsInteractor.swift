//
//  KarhooUpdateUserDetailsInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooUpdateUserDetailsInteractor: UpdaterUserDetailsInteractor {
    
    private var userDetailsUpdate: UserDetailsUpdateRequest?
    private let requestSender: RequestSender
    private let userDataStore: UserDataStore
    private let analyticsService: AnalyticsService
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         userDataStore: UserDataStore = DefaultUserDataStore(),
         analyticsService: AnalyticsService = Karhoo.getAnalyticsService()) {
        self.requestSender = requestSender
        self.userDataStore = userDataStore
        self.analyticsService = analyticsService
    }
    
    func set(update: UserDetailsUpdateRequest) {
        self.userDetailsUpdate = update
    }
    
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let userUpdateDetails = self.userDetailsUpdate else {
            return
        }
        
        guard let userId = userDataStore.getCurrentUser()?.userId else {
            callback(Result.failure(error: SDKErrorFactory.getLoginPermissionError()))
            return
        }

        requestSender.requestAndDecode(payload: userUpdateDetails,
                                       endpoint: APIEndpoint.userProfileUpdate(identifier: userId),
                                       callback: { [weak self] (result: Result<UserInfo>) in
                                        switch result {
                                        case .success(var result):
                                            self?.userDataStore.updateUser(user: &result.result)
                                            self?.analyticsService.send(eventName: .userProfileUpdateSuccess)
                                            guard let user = result.result as? T else {
                                                return
                                            }
                                            callback(.success(result: user))
                                        case .failure(let error):
                                            self?.analyticsService.send(eventName: .userProfleUpdateFailed)
                                            callback(.failure(error: error.error))
                                        }
        })
    }
    
    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
