//
//  LocationInfo.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct LocationInfo: KarhooCodableModel {

    public let position: Position
    public let placeId: String
    public let poiType: PoiType
    public let address: LocationInfoAddress
    public let timeZoneIdentifier: String
    public let details: PoiDetails
    public let meetingPoint: MeetingPoint
    public let instructions: String

    public init(placeId: String = "",
                timeZoneIdentifier: String = "",
                position: Position = Position(),
                poiType: PoiType = .notSetPoiType,
                address: LocationInfoAddress = LocationInfoAddress(),
                details: PoiDetails = PoiDetails(),
                meetingPoint: MeetingPoint = MeetingPoint(),
                instructions: String = "") {
        self.placeId = placeId
        self.timeZoneIdentifier = timeZoneIdentifier
        self.position = position
        self.poiType = poiType
        self.address = address
        self.details = details
        self.meetingPoint = meetingPoint
        self.instructions = instructions
    }

    enum CodingKeys: String, CodingKey {
        case position
        case placeId = "place_id"
        case poiType = "poi_type"
        case address
        case timeZoneIdentifier = "time_zone"
        case details
        case meetingPoint = "meeting_point"
        case instructions
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.position = (try? container.decodeIfPresent(Position.self, forKey: .position)) ?? Position()
        self.placeId = (try? container.decodeIfPresent(String.self, forKey: .placeId)) ?? ""
        self.poiType = (try? container.decodeIfPresent(PoiType.self, forKey: .poiType)) ?? .notSetPoiType
        self.address = (try? container.decodeIfPresent(LocationInfoAddress.self, forKey: .address)) ?? LocationInfoAddress()
        self.timeZoneIdentifier = (try? container.decodeIfPresent(String.self, forKey: .timeZoneIdentifier)) ?? ""
        self.details = (try? container.decodeIfPresent(PoiDetails.self, forKey: .details)) ?? PoiDetails()
        self.meetingPoint = (try? container.decodeIfPresent(MeetingPoint.self, forKey: .meetingPoint)) ?? MeetingPoint()
        self.instructions = (try? container.decodeIfPresent(String.self, forKey: .instructions)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(position, forKey: .position)
        try container.encode(placeId, forKey: .placeId)
        try container.encode(poiType, forKey: .poiType)
        try container.encode(address, forKey: .address)
        try container.encode(timeZoneIdentifier, forKey: .timeZoneIdentifier)
        try container.encode(details, forKey: .details)
        try container.encode(meetingPoint, forKey: .meetingPoint)
        try container.encode(instructions, forKey: .instructions)
    }
}
