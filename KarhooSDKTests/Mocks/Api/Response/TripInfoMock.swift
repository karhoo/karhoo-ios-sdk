//
//  TripInfoMock.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class TripInfoMock {

    private var tripInfo: TripInfo

    init() {
        self.tripInfo = TripInfo(tripId: "",
                                 displayId: "",
                                 origin: TripLocationDetails(),
                                 destination: TripLocationDetails(),
                                 dateScheduled: nil,
                                 state: .unknown,
                                 quote: TripQuote(),
                                 vehicle: Vehicle(),
                                 fleetInfo: FleetInfo(),
                                 meetingPoint: nil)
    }

    func set(tripId: String) -> TripInfoMock {
        create(tripId: tripId)
        return self
    }

    func set(displayId: String) -> TripInfoMock {
        create(displayId: displayId)
        return self
    }

    func set(origin: TripLocationDetails) -> TripInfoMock {
        create(origin: origin)
        return self
    }

    func set(destination: TripLocationDetails) -> TripInfoMock {
        create(destination: destination)
        return self
    }

    func set(dateScheduled: Date) -> TripInfoMock {
        create(dateScheduled: dateScheduled)
        return self
    }

    func set(state: TripState) -> TripInfoMock {
        create(state: state)
        return self
    }

    func set(quote: TripQuote) -> TripInfoMock {
        create(quote: quote)
        return self
    }

    func set(vehicle: Vehicle) -> TripInfoMock {
        create(vehicle: vehicle)
        return self
    }

    func set(driver: Driver) -> TripInfoMock {
        create(driver: driver)
        return self
    }

    func set(fleetInfo: FleetInfo) -> TripInfoMock {
        create(fleetInfo: fleetInfo)
        return self
    }

    func set(meethingPoint: MeetingPoint) -> TripInfoMock {
        create(meetingPoint: meethingPoint)
        return self
    }

    func create(tripId: String? = nil,
                displayId: String? = nil,
                origin: TripLocationDetails? = nil,
                destination: TripLocationDetails? = nil,
                dateScheduled: Date? = nil,
                state: TripState? = nil,
                quote: TripQuote? = nil,
                vehicle: Vehicle? = nil,
                driver: Driver? = nil,
                fleetInfo: FleetInfo? = nil,
                meetingPoint: MeetingPoint? = nil) {
        tripInfo = TripInfo(tripId: tripId ?? tripInfo.tripId,
                            displayId: displayId ?? tripInfo.displayId,
                            origin: origin ?? tripInfo.origin,
                            destination: destination ?? tripInfo.destination ,
                            dateScheduled: dateScheduled ?? tripInfo.dateScheduled,
                            state: state ?? tripInfo.state,
                            quote: quote ?? tripInfo.tripQuote,
                            vehicle: vehicle ?? tripInfo.vehicle,
                            fleetInfo: fleetInfo ?? tripInfo.fleetInfo,
                            meetingPoint: meetingPoint ?? tripInfo.meetingPoint)
    }

    func build() -> TripInfo {
        return tripInfo
    }
}
