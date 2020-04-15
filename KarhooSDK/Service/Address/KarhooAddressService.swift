//
//  KarhooAddressService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooAddressService: AddressService {

    private let placeSearchInteractor: PlaceSearchInteractor
    private let locationInfoInteractor: LocationInfoInteractor
    private let reverseGeocodeInteractor: ReverseGeocodeInteractor

    init(placeSearchInteractor: PlaceSearchInteractor = KarhooPlaceSearchInteractor(),
         locationInfoInteractor: LocationInfoInteractor = KarhooLocationInfoInteractor(),
         reverseGeocodeInteractor: ReverseGeocodeInteractor = KarhooReverseGeocodeInteractor()) {
        self.placeSearchInteractor = placeSearchInteractor
        self.locationInfoInteractor = locationInfoInteractor
        self.reverseGeocodeInteractor = reverseGeocodeInteractor
    }

    func placeSearch(placeSearch: PlaceSearch) -> Call<Places> {
        placeSearchInteractor.set(placeSearch: placeSearch)
        return Call(executable: placeSearchInteractor)
    }

    func locationInfo(locationInfoSearch: LocationInfoSearch) -> Call<LocationInfo> {
        locationInfoInteractor.set(locationInfoSearch: locationInfoSearch)
        return Call(executable: locationInfoInteractor)
    }

    func reverseGeocode(position: Position) -> Call<LocationInfo> {
        reverseGeocodeInteractor.set(position: position)
        return Call(executable: reverseGeocodeInteractor)
    }
}
