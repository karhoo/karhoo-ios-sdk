//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooPasswordResetInteractor: PasswordResetInteractor {
    private var email: String?
    private let requestSender: RequestSender

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared)) {
        self.requestSender = requestSender
    }

    func set(email: String) {
        self.email = email
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let email = self.email else {
            return
        }

        requestSender.request(payload: PasswordResetRequestPayload(email: email),
                             endpoint: .passwordReset,
                             callback: { result in
                                guard result.getSuccessValue(orErrorCallback: callback) != nil,
                                let success = KarhooVoid() as? T else {
                                    return
                                }

                                callback(.success(result: success))
        })
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
