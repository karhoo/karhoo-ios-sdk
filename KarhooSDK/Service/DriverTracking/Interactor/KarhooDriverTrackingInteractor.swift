//
//  KarhooDriverTrackingInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooDriverTrackingInteractor: KarhooExecutable {

    private let tripId: String
    private let requestSender: RequestSender

    init(tripId: String,
         requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.tripId = tripId
        self.requestSender = requestSender
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        requestSender.requestAndDecode(payload: nil,
                                       endpoint: endpoint(),
                                       callback: callback)
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }

    private func endpoint() -> APIEndpoint {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return .trackDriverFollowCode(followCode: tripId)
        }

        return .trackDriver(identifier: tripId)
    }
}
