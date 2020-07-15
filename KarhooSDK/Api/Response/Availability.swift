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
        self.vehicles = (try? container.decode(VehicleAvailability.self, forKey: .vehicles)) ?? VehicleAvailability()
    }
}

public struct VehicleAvailability: KarhooCodableModel {

    public let classes: [String]

    public init(classes: [String] = [""]) {
        self.classes = classes
    }

    enum CodingKeys: String, CodingKey {
        case classes
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.classes = (try? container.decode(Array.self, forKey: .classes)) ?? []
    }
}
