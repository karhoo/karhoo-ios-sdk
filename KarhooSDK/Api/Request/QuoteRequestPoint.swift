//
//  QuoteRequestPoint.swift
//  KarhooSDK
//
//  Created by Jeevan Thandi on 15/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

struct QuoteRequestPoint: KarhooCodableModel {

    let latitude: String
    let longitude: String
    let displayAddress: String?

    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case displayAddress = "display_address"
    }
}
