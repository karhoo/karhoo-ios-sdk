//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum PoiDetailsType: String, Codable {
    case notSetDetailsType = "NOT_SET_DETAILS_TYPE"
    case airport = "AIRPORT"
    case trainStation = "TRAIN_STATION"
    case metroStation = "METRO_STATION"
    case port = "PORT"
    case hotel = "HOTEL"
    case other = "OTHER"
}
