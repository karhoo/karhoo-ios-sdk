//
//  MeetingPointType.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum MeetingPointType: String, Codable {
    case `default` = "DEFAULT",
    pickup = "PICK_UP",
    dropOff = "DROP_OFF",
    meetAndGreet = "MEET_AND_GREET",
    curbSide = "CURB_SIDE",
    standBy = "STAND_BY",
    notSet = "NOT_SET"
}
