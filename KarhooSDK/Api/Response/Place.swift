//
//  Place.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Place: KarhooCodableModel {

    public let placeId: String
    public let displayAddress: String
    public let poiDetailsType: PoiDetailsType

    public init(placeId: String = "",
                displayAddress: String = "",
                poiDetailsType: PoiDetailsType = .notSetDetailsType) {
        self.placeId = placeId
        self.displayAddress = displayAddress
        self.poiDetailsType = poiDetailsType
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.placeId = (try? container.decode(String.self, forKey: .placeId)) ?? ""
        self.displayAddress = (try? container.decode(String.self, forKey: .displayAddress)) ?? ""
        self.poiDetailsType = (try? container.decode(PoiDetailsType.self,
                                                     forKey: .poiDetailsType)) ?? .notSetDetailsType
    }

    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case displayAddress = "display_address"
        case poiDetailsType = "type"
    }
}
