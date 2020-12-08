//
//  DriverTrackingInfo.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

typealias DriverTrackingInfoKeys = DriverTrackingInfo.CodingKeys

public struct DriverTrackingInfo: KarhooCodableModel {

    public let position: Position
    public let direction: Direction
    public let originEta: Int
    public let destinationEta: Int

    public init(position: Position,
                direction: Direction,
                originEta: Int,
                destinationEta: Int) {
        self.position = position
        self.direction = direction
        self.originEta = originEta
        self.destinationEta = destinationEta
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.position = (try? container.decode(Position.self, forKey: .position)) ?? Position(latitude: 0, longitude: 0)
        self.direction = (try? container.decode(Direction.self, forKey: .direction)) ?? Direction(kph: 0, heading: 0)
        self.originEta = (try? container.decode(Int.self, forKey: .originEta)) ?? 0
        self.destinationEta = (try? container.decode(Int.self, forKey: .destinationEta)) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(position, forKey: .position)
        try container.encode(direction, forKey: .direction)
        try container.encode(originEta, forKey: .originEta)
        try container.encode(destinationEta, forKey: .destinationEta)
    }

    enum CodingKeys: String, CodingKey {
        case position
        case direction
        case originEta = "origin_eta"
        case destinationEta = "destination_eta"
    }
}
