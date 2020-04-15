//
//  KarhooTripUpdateInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooTripUpdateInteractor: TripUpdateInteractor {

    private let tripId: String
    private let requestSender: RequestSender

    init(tripId: String,
         requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.tripId = tripId
        self.requestSender = requestSender
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        requestSender.requestAndDecode(payload: nil,
                                       endpoint: .trackTrip(identifier: tripId),
                                       callback: callback)
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
