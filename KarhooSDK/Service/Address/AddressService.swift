//
//  AddressService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol AddressService {

    func placeSearch(placeSearch: PlaceSearch) -> Call<Places>

    func locationInfo(locationInfoSearch: LocationInfoSearch) -> Call<LocationInfo>

    func reverseGeocode(position: Position) -> Call<LocationInfo>
}
