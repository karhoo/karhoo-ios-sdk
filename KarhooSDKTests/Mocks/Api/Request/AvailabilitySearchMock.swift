//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class AvailabilitySearchMock {

    private var availabilitySearch: AvailabilitySearch

    init() {
        self.availabilitySearch = AvailabilitySearch(origin: "", destination: "", dateScheduled: nil)
    }

    func setOrigin(origin: String) -> AvailabilitySearchMock {
        self.availabilitySearch = AvailabilitySearch(
                origin: origin,
                destination: availabilitySearch.destinationPlaceId,
                dateScheduled: availabilitySearch.dateScheduled)
        return self
    }

    func setDestination(destination: String) -> AvailabilitySearchMock {
        self.availabilitySearch = AvailabilitySearch(
                origin: availabilitySearch.originPlaceId,
                destination: destination,
                dateScheduled: availabilitySearch.dateScheduled)
        return self
    }

    func setDateScheduled(dateScheduled: String) -> AvailabilitySearchMock {
        self.availabilitySearch = AvailabilitySearch(
                origin: availabilitySearch.originPlaceId,
                destination: availabilitySearch.destinationPlaceId,
                dateScheduled: dateScheduled)
        return self
    }

    func build() -> AvailabilitySearch {
        return availabilitySearch
    }
}
