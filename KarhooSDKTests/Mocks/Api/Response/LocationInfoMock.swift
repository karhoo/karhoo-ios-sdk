//
//  LocationInfoMock.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class LocationInfoMock {

    private var locationInfo: LocationInfo

    init() {
        self.locationInfo = LocationInfo(placeId: "", timeZoneIdentifier: "")
    }

    func set(placeId: String) -> LocationInfoMock {
        create(placeId: placeId)
        return self
    }

    func set(timeZoneIdentifier: String) -> LocationInfoMock {
        create(timeZoneIdentifier: timeZoneIdentifier)
        return self
    }

    func set(position: Position) -> LocationInfoMock {
        create(position: position)
        return self
    }

    func set(poiType: PoiType) -> LocationInfoMock {
        create(poiType: poiType)
        return self
    }

    func set(address: LocationInfoAddress) -> LocationInfoMock {
        create(address: address)
        return self
    }

    func set(details: PoiDetails) -> LocationInfoMock {
        create(details: details)
        return self
    }

    func set(meetingPoint: MeetingPoint) -> LocationInfoMock {
        create(meetingPoint: meetingPoint)
        return self
    }

    func set(instructions: String) -> LocationInfoMock {
        create(instructions: instructions)
        return self
    }

    private func create(placeId: String? = nil,
                        timeZoneIdentifier: String? = nil,
                        position: Position? = nil,
                        poiType: PoiType? = nil,
                        address: LocationInfoAddress? = nil,
                        details: PoiDetails? = nil,
                        meetingPoint: MeetingPoint? = nil,
                        instructions: String? = nil) {
        locationInfo = LocationInfo(placeId: placeId ?? locationInfo.placeId,
                                    timeZoneIdentifier: timeZoneIdentifier ?? locationInfo.timeZoneIdentifier,
                                    position: position ?? locationInfo.position,
                                    poiType: poiType ?? locationInfo.poiType,
                                    address: address ?? locationInfo.address,
                                    details: details ?? locationInfo.details,
                                    meetingPoint: meetingPoint ?? locationInfo.meetingPoint,
                                    instructions: instructions ?? locationInfo.instructions)
    }

    func build() -> LocationInfo {
        return locationInfo
    }
}
