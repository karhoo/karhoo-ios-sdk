//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Places: KarhooCodableModel {

    public let places: [Place]

    public init(places: [Place] = []) {
        self.places = places
    }

    enum CodingKeys: String, CodingKey {
        case places = "locations"
    }
}
