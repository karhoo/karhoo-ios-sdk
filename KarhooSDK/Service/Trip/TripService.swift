//
//  TripService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol TripService {
    func book(tripBooking: TripBooking) -> Call<TripInfo>

    func cancel(tripCancellation: TripCancellation) -> Call<KarhooVoid>

    func search(tripSearch: TripSearch) -> Call<[TripInfo]>

    func trackTrip(identifier: String) -> PollCall<TripInfo>

    func status(tripId: String) -> PollCall<TripState>
}
