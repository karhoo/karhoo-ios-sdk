//
//  KarhooAddressSearchProvider.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooPlaceSearchInteractor: PlaceSearchInteractor {

    private let requestSender: RequestSender
    private var placeSearch: PlaceSearch?

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.requestSender = requestSender
    }

    func set(placeSearch: PlaceSearch) {
        self.placeSearch = placeSearch
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let placeSearch = self.placeSearch else {
            return
        }

        requestSender.requestAndDecode(payload: placeSearch,
                                       endpoint: .placeSearch,
                                       callback: callback)
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
