//
//  BookingInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol BookingInteractor: KarhooExecutableWithCorrelationId {
    func set(tripBooking: TripBooking)
}
