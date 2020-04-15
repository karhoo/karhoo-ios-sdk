//
//  KarhooRegisterInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooRegisterInteractor: RegisterInteractor {

    private let requestSender: RequestSender
    private var userRegistration: UserRegistration?

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared)) {
        self.requestSender = requestSender
    }

    func set(userRegistration: UserRegistration) {
        self.userRegistration = userRegistration
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let userRegistration = self.userRegistration else {
            return
        }

        requestSender.requestAndDecode(payload: userRegistration,
                                       endpoint: .register,
                                       callback: callback)
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
