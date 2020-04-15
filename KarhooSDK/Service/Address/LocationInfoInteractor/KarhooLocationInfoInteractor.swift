//
//  KarhooLocationInfoInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooLocationInfoInteractor: LocationInfoInteractor {

    private let requestSender: RequestSender
    private var locationInfoSearch: LocationInfoSearch?

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.requestSender = requestSender
    }

    func set(locationInfoSearch: LocationInfoSearch) {
        self.locationInfoSearch = locationInfoSearch
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let locationInfoSearch = self.locationInfoSearch else {
            return
        }
        requestSender.requestAndDecode(payload: locationInfoSearch,
                                       endpoint: .locationInfo,
                                       callback: callback)
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
