//
//  KarhooLogoutInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooLogoutInteractor: KarhooExecutable {
    private let userDataStore: UserDataStore
    private let analytics: AnalyticsService

    init(userDataStore: UserDataStore = DefaultUserDataStore(),
         analytics: AnalyticsService = KarhooAnalyticsService()) {
        self.userDataStore = userDataStore
        self.analytics = analytics
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let _ = userDataStore.getCurrentUser() else {
            callback(Result.failure(error: nil))
            return
        }

        guard let result = KarhooVoid() as? T else {
            return
        }

        analytics.send(eventName: AnalyticsConstants.EventNames.userLoggedOut)

        userDataStore.removeCurrentUserAndCredentials()
        callback(Result.success(result: result))
    }

    func cancel() { }
}
