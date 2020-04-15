//
//  KarhooUIConfigInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

class KarhooUIConfigInteractor: UIConfigInteractor {

    private let userDataStore: UserDataStore
    private let uiConfigProvider: UIConfigProvider
    private var uiConfigRequest: UIConfigRequest?

    init(userDataStore: UserDataStore = DefaultUserDataStore(),
         uiConfigProvider: UIConfigProvider = KarhooUIConfigProvider()) {
        self.userDataStore = userDataStore
        self.uiConfigProvider = uiConfigProvider
    }

    func set(uiConfigRequest: UIConfigRequest) {
        self.uiConfigRequest = uiConfigRequest
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let typedCallback = callback as? CallbackClosure<UIConfig> else {
            return
        }

        guard let request = uiConfigRequest else {
            typedCallback(.failure(error: SDKErrorFactory.unexpectedError()))
            return
        }

        guard let userOrg = userDataStore.getCurrentUser()?.organisations[0] else {
            typedCallback(.failure(error: SDKErrorFactory.getLoginPermissionError()))
            return
        }

        uiConfigProvider.fetchConfig(uiConfigRequest: request, organisation: userOrg, callback: typedCallback)
    }

    func cancel() {}
}
