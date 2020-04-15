//
//  CancelReason.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum CancelReason: String {
    case askedByDriverToCancel = "ASKED_BY_DRIVER_TO_CANCEL"
    case notNeededAnymore = "NOT_NEEDED_ANYMORE"
    case cannotFindVehicle = "CAN_NOT_FIND_VEHICLE"
    case driverIsLate = "DRIVER_IS_LATE"
    case etaTooLong = "ETA_TOO_LONG"
    case driverDidntShowUp = "DRIVER_DIDNT_SHOW_UP"
    case otherUserReason = "OTHER_USER_REASON"
}
