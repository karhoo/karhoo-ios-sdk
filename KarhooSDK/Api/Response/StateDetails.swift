//
//  StateDetails.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 07/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public enum StateDetails: String, KarhooCodableModel {
    
    //Dispatch cancellation reasons
    case requestedByUser = "REQUESTED_BY_USER"
    case passengerDidntShowUp = "PASSENGER_DIDNT_SHOW_UP"
    case driverCanceled = "DRIVER_CANCELED"
    case supplierCancelled = "SUPPLIER_CANCELLED"
    case dispatchCancelled = "DISPATCH_CANCELLED"
    case noAvailabilityInTheArea = "NO_AVAILABILITY_IN_THE_AREA"
    case noFee = "NO_FEE"
    case otherDispatchReason = "OTHER_DISPATCH_REASON"
    
    //User cancellation reasons
    case driverDidntShowUp = "DRIVER_DIDNT_SHOW_UP"
    case etaTooLong = "ETA_TOO_LONG"
    case driverIsLate = "DRIVER_IS_LATE"
    case cannotFindVehicle = "CAN_NOT_FIND_VEHICLE"
    case notNeededANymore = "NOT_NEEDED_ANYMORE"
    case askedByDriverToCancel = "ASKED_BY_DRIVER_TO_CANCEL"
    case foundBetterPrice = "FOUND_BETTER_PRICE"
    case notClearMeetingInstructions = "NOT_CLEAR_MEETING_INSTRUCTIONS"
    case couldNotContactCarrier = "COULD_NOT_CONTACT_CARRIER"
    
    //Karhoo cancellation reasons
    case fraud = "FRAUD"
    case noAvailability = "NO_AVAILABILITY"
    case askedByUser = "ASKED_BY_USER"
    case askedBydispatch = "ASKED_BY_DISPATCH"
    case askedByDriver = "ASKED_BY_DRIVER"
    case failure = "FAILIURE"
    case preauthFailed = "PREAUTH_FAILED"
    case otherKarhooReason = "OTHER_KARHOO_REASON"
}
