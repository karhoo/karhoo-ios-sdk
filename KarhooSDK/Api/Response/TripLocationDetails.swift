//
//  TripLocationDetails.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct TripLocationDetails: Codable {

    public let displayAddress: String
    public let placeId: String
    public let position: Position
    public let timeZoneIdentifier: String

    public init(displayAddress: String = "",
                placeId: String = "",
                position: Position = Position(),
                timeZoneIdentifier: String = "") {
        self.displayAddress = displayAddress
        self.placeId = placeId
        self.position = position
        self.timeZoneIdentifier = timeZoneIdentifier
    }

    enum CodingKeys: String, CodingKey {
        case displayAddress = "display_address"
        case placeId = "place_id"

        //Backend should really send us "time_zone" (https://jira.flit.tech/browse/PLATFORM-1859)
        case timeZoneIdentifier = "timezone"

        case position = "position"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.displayAddress = (try? container.decode(String.self, forKey: .displayAddress)) ?? ""
        self.placeId = (try? container.decode(String.self, forKey: .placeId)) ?? ""
        self.position = (try? container.decode(Position.self, forKey: .position)) ?? Position()
        self.timeZoneIdentifier = (try? container.decode(String.self, forKey: .timeZoneIdentifier)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(displayAddress, forKey: .displayAddress)
        try container.encode(placeId, forKey: .placeId)
        try container.encode(position, forKey: .position)
        try container.encode(timeZoneIdentifier, forKey: .timeZoneIdentifier)
    }
}
