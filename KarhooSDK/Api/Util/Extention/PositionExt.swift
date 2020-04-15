//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation

public extension Position {
    func isValid() -> Bool {
        return self.latitude == 0 && self.longitude == 0 ? false : true
    }

    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude,
                          longitude: self.longitude)
    }
}
