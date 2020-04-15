//
//  AvailabilityService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol AvailabilityService {
    func availability(availabilitySearch: AvailabilitySearch) -> Call<Categories>
}
