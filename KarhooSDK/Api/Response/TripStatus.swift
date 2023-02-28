//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

struct TripStatus: KarhooCodableModel {

    public let status: TripState

    public init(status: TripState) {
        self.status = status
    }

    enum CodingKeys: String, CodingKey {
        case status
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = (try? container.decodeIfPresent(TripState.self, forKey: .status)) ?? .unknown
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
    }
}
