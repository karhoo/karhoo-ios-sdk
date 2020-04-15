//
//  KarhooAvailabilityService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooAvailabilityService: AvailabilityService {

    private let availabilityInteractor: AvailabilityInteractor

    init(availabilityInteractor: AvailabilityInteractor = KarhooAvailabilityInteractor()) {
        self.availabilityInteractor = availabilityInteractor
    }

    func availability(availabilitySearch: AvailabilitySearch) -> Call<Categories> {
        availabilityInteractor.set(availabilitySearch: availabilitySearch)
        return Call(executable: availabilityInteractor)
    }
}
