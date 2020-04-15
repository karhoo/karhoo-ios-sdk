//
//  TripState.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum TripState: String, KarhooCodableModel {
    case requested = "REQUESTED"
    case noDriversAvailable = "NO_DRIVERS_AVAILABLE"
    case confirmed = "CONFIRMED"
    case driverEnRoute = "DRIVER_EN_ROUTE"
    case arrived = "ARRIVED"
    case passengerOnBoard = "POB"
    case completed = "COMPLETED"
    case bookerCancelled = "BOOKER_CANCELLED"
    case driverCancelled = "DRIVER_CANCELLED"
    case karhooCancelled = "KARHOO_CANCELLED"
    case failed = "FAILED"
    case incomplete = "INCOMPLETE"
    case unknown = "UNKNOWN"
}
