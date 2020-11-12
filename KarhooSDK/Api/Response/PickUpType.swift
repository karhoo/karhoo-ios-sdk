//
//  PickupType.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum PickUpType: String, Codable {

    case `default` = "DEFAULT"
    case meetAndGreet = "MEET_AND_GREET"
    case curbside = "CURBSIDE"
    case standyBy = "STAND_BY"
}
