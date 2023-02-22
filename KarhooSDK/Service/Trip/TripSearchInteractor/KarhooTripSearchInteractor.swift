//
//  KarhooTripSearchInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooTripSearchInteractor: TripSearchInteractor {

    private let requestSender: RequestSender
    private var tripSearch: TripSearch?

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.requestSender = requestSender
    }

    func set(tripSearch: TripSearch) {
        self.tripSearch = tripSearch
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let tripSearch = self.tripSearch else { return }

        requestSender.requestAndDecode(payload: tripSearch,
                                       endpoint: .tripSearch) { (result: Result<BookingSearch>) in
                                        guard let bookingList = result.getSuccessValue(orErrorCallback: callback),
                                               let result = bookingList.trips as? T else { return }
                                         callback(.success(result: result))
        }
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
