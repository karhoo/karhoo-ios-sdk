//
//  KarhooVoid.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

/**
  * A way to represent 'Void' in KarhooCall/KarhooPollableCall result values
  * as Void is not codable.
  */
public struct KarhooVoid: KarhooCodableModel {

    public init() {}

}
