//
//  KarhooFareService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooFareService: FareService {
    
    private let fareInteractor: FareInteractor
    
    init(fareInteractor: FareInteractor = KarhooFareInteractor()) {
        self.fareInteractor = fareInteractor
    }
    
    func fareDetails(tripId: String) -> Call<Fare> {
        fareInteractor.set(tripId: tripId)
        return Call(executable: fareInteractor)
    }
}
