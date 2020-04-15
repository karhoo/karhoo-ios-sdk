//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class DriverTrackingInfoMock {

    private var driverTrackingInfo: DriverTrackingInfo

    init() {
        self.driverTrackingInfo = DriverTrackingInfo(position: Position(latitude: 0, longitude: 0),
                                                     originEta: 0,
                                                     destinationEta: 0)
    }

    func setPosition(position: Position) -> DriverTrackingInfoMock {
        create(position: position)
        return self
    }

    func setOriginEta(originEta: Int) -> DriverTrackingInfoMock {
        create(originEta: originEta)
        return self
    }

    func setDestinationEta(destinationEta: Int) -> DriverTrackingInfoMock {
        create(destinationEta: destinationEta)
        return self
    }

    func create(position: Position? = nil,
                originEta: Int? = nil,
                destinationEta: Int? = nil) {
        driverTrackingInfo = DriverTrackingInfo(position: position ?? driverTrackingInfo.position,
                                                originEta: originEta ?? driverTrackingInfo.originEta,
                                                destinationEta: destinationEta ?? driverTrackingInfo.destinationEta)
    }

    func build() -> DriverTrackingInfo {
        return driverTrackingInfo
    }
}
