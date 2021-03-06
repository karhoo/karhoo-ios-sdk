//
//  CoverageRequest.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 10/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct QuoteCoverageRequest: KarhooCodableModel {

   public let latitude: String
   public let longitude: String
   public let localTimeOfPickup: String?
    
    public init(latitude: String = "",
                longitude: String = "",
                localTimeOfPickup: String? = "") {
        self.latitude = latitude
        self.longitude = longitude
        self.localTimeOfPickup = localTimeOfPickup
    }

    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case localTimeOfPickup = "local_time_of_pickup"
    }
}
