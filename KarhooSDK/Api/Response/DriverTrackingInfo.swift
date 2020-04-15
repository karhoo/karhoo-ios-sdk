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
    public let originEta: Int
    public let destinationEta: Int

    public init(position: Position,
                originEta: Int,
                destinationEta: Int) {
        self.position = position
        self.originEta = originEta
        self.destinationEta = destinationEta
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.position = (try? container.decode(Position.self, forKey: .position)) ?? Position(latitude: 0, longitude: 0)
        self.originEta = (try? container.decode(Int.self, forKey: .originEta)) ?? 0
        self.destinationEta = (try? container.decode(Int.self, forKey: .destinationEta)) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(position, forKey: .position)
        try container.encode(originEta, forKey: .originEta)
        try container.encode(destinationEta, forKey: .destinationEta)
    }

    enum CodingKeys: String, CodingKey {
        case position
        case originEta = "origin_eta"
        case destinationEta = "destination_eta"
    }
}
