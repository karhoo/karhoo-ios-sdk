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

public struct DecodableData: KarhooCodableModel {

    public let data: Data
    public init(data: Data) {
        self.data = data
    }
}
