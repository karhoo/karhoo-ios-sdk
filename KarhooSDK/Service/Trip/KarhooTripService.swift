//
//  KarhooTripService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooTripService: TripService {
    private let bookingInteractor: BookingInteractor
    private let cancelTripInteractor: CancelTripInteractor
    private let tripSearchInteractor: TripSearchInteractor
    private let analytics: AnalyticsService
    private let tripPollFactory: PollCallFactory
    private let tripStatusPollFactory: PollCallFactory
    private let cancellationFeeInteractor: CancellationFeeInteractor

    init(bookingInteractor: BookingInteractor = KarhooBookingInteractor(),
         cancelTripInteractor: CancelTripInteractor = KarhooCancelTripInteractor(),
         tripSearchInteractor: TripSearchInteractor = KarhooTripSearchInteractor(),
         analytics: AnalyticsService = KarhooAnalyticsService(),
         tripPollFactory: PollCallFactory = KarhooPollCallFactory(),
         tripStatusPollFactory: PollCallFactory = KarhooPollCallFactory(),
         cancellationFeeInteractor: CancellationFeeInteractor = KarhooCancellationFeeInteractor()) {

        self.bookingInteractor = bookingInteractor
        self.cancelTripInteractor = cancelTripInteractor
        self.analytics = analytics
        self.tripSearchInteractor = tripSearchInteractor
        self.tripPollFactory = tripPollFactory
        self.tripStatusPollFactory = tripStatusPollFactory
        self.cancellationFeeInteractor = cancellationFeeInteractor
    }

    func book(tripBooking: TripBooking) -> Call<TripInfo> {
        bookingInteractor.set(tripBooking: tripBooking)
        return Call(executable: bookingInteractor)
    }

    func cancel(tripCancellation: TripCancellation) -> Call<KarhooVoid> {
        cancelTripInteractor.set(tripCancellation: tripCancellation)
        return Call(executable: cancelTripInteractor)
    }

    func search(tripSearch: TripSearch) -> Call<[TripInfo]> {
        tripSearchInteractor.set(tripSearch: tripSearch)
        return Call(executable: tripSearchInteractor)
    }

    func trackTrip(identifier: String) -> PollCall<TripInfo> {
        let interactor = KarhooTripUpdateInteractor(identifier: identifier)
        return tripPollFactory.shared(identifier: identifier,
                                      executable: interactor)
    }

    func status(tripId: String) -> PollCall<TripState> {
        let interactor = KarhooTripStatusInteractor(tripId: tripId)
        return tripStatusPollFactory.shared(identifier: tripId,
                                            executable: interactor)
    }
    
    func cancellationFee(identifier: String) -> Call<CancellationFee> {
        cancellationFeeInteractor.set(identifier: identifier)
        return Call(executable: cancellationFeeInteractor)
    }
}
