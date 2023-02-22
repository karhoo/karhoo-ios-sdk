//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Availability: KarhooCodableModel {

    public let vehicles: VehicleAvailability

    enum CodingKeys: String, CodingKey {
        case vehicles
    }

    init(vehicles: VehicleAvailability = VehicleAvailability()) {
        self.vehicles = vehicles
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.vehicles = (try? container.decodeIfPresent(VehicleAvailability.self, forKey: .vehicles)) ?? VehicleAvailability()
    }
}
