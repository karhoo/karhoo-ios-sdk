//
//  KarhooReverseGeocodeInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooReverseGeocodeInteractor: ReverseGeocodeInteractor {

    private let requestSender: RequestSender
    private var position: Position?

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.requestSender = requestSender
    }

    func set(position: Position) {
        self.position = position
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let position = self.position else {
            return
        }

        requestSender.requestAndDecode(payload: nil,
                                       endpoint: .reverseGeocode(position: position),
                                       callback: callback)
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
