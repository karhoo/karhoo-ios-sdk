//
//  FareService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol FareService {
    func fareDetails(tripId: String) -> Call<Fare>
}
