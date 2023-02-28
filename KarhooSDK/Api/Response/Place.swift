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

        self.placeId = (try? container.decodeIfPresent(String.self, forKey: .placeId)) ?? ""
        self.displayAddress = (try? container.decodeIfPresent(String.self, forKey: .displayAddress)) ?? ""
        self.poiDetailsType = (try? container.decodeIfPresent(PoiDetailsType.self,
                                                     forKey: .poiDetailsType)) ?? .notSetDetailsType
    }

    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case displayAddress = "display_address"
        case poiDetailsType = "type"
    }
}
