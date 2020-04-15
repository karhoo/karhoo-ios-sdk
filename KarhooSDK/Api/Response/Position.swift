//
//  Position.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Position: KarhooCodableModel, Equatable {

    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double = 0,
                longitude: Double = 0) {
        self.latitude = latitude
        self.longitude = longitude
    }

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = (try? container.decode(Double.self, forKey: .latitude)) ?? 0
        self.longitude = (try? container.decode(Double.self, forKey: .longitude)) ?? 0
    }
}
