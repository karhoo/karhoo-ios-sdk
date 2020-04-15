//
//  CancelTripInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol CancelTripInteractor: KarhooExecutable {
    func set(tripCancellation: TripCancellation)
}
