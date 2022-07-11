//
//  KarhooBookingInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooBookingInteractor: BookingInteractor {

    private let bookingRequest: RequestSender
    private var tripBooking: TripBooking?

    init(bookingRequest: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.bookingRequest = bookingRequest
    }

    func set(tripBooking: TripBooking) {
        self.tripBooking = tripBooking
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosureWithCorrelationId<T>) {
        guard let tripBooking = self.tripBooking else {
            return
        }

        var bookingEndpoint: APIEndpoint = .bookTrip

        if tripBooking.paymentNonce != nil {
            bookingEndpoint = .bookTripWithNonce
        }

        bookingRequest.requestAndDecode(payload: tripBooking,
                                        endpoint: bookingEndpoint,
                                        callback: callback)
    }

    func cancel() {
        bookingRequest.cancelNetworkRequest()
    }
}
