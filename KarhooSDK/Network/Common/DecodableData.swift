//
//  DecodableData.swift
//  KarhooSDK
//
//  Created by Jeevan Thandi on 09/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct DecodableData: KarhooCodableModel {

    public let data: Data
    public init(data: Data) {
        self.data = data
    }
}
