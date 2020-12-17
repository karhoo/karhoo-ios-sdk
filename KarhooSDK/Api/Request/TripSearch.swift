//
//  TripSearch.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct TripSearch: KarhooCodableModel {

    public let tripStates: [TripState]?
    public let tripType: TripType?
    public let paginationRowCount: Int?
    public let paginationOffset: Int?
    public let fleetID: String?
    public let partnerTravellerID: String?
    public let partnerTripID: String?
    public let externalTripID: String?
    public let displayTripID: String?
    public let forename: String?
    public let lastname: String?
    public let email: String?
    public let createdAfter: String?
    public let prebookTimeAfter: String?
    public let prebookTimeBefore: String?
    public let tripTimeBefore: String?
    public let tripTimeAfter: String?
    public let onlyWithoutFinalPrice: Bool?
    public let orderBy: [String]
    
    public init(tripStates: [TripState]? = nil,
                tripType: TripType? = .both,
                paginationRowCount: Int? = nil,
                paginationOffset: Int? = nil,
                fleetID: String? = "",
                partnerTravellerID: String? = nil,
                partnerTripID: String? = nil,
                externalTripID: String? = nil,
                displayTripID: String? = "",
                forename: String? = nil,
                lastname: String? = nil,
                email: String? = nil,
                createdAfter: String? = nil,
                prebookTimeAfter: String? = nil,
                prebookTimeBefore: String? = nil,
                tripTimeBefore: String? = nil,
                tripTimeAfter: String? = nil,
                onlyWithoutFinalPrice: Bool? = false,
                orderBy: [String] = []) {
        self.tripStates = tripStates
        self.tripType = tripType
        self.paginationRowCount = paginationRowCount
        self.paginationOffset = paginationOffset
        self.fleetID = fleetID
        self.partnerTravellerID = partnerTravellerID
        self.partnerTripID = partnerTripID
        self.externalTripID = externalTripID
        self.displayTripID = displayTripID
        self.forename = forename
        self.lastname = lastname
        self.email = email
        self.createdAfter = createdAfter
        self.prebookTimeAfter = prebookTimeAfter
        self.prebookTimeBefore = prebookTimeBefore
        self.tripTimeBefore = tripTimeBefore
        self.tripTimeAfter = tripTimeAfter
        self.onlyWithoutFinalPrice = onlyWithoutFinalPrice
        self.orderBy = orderBy
    }
    
    enum CodingKeys: String, CodingKey {
        case tripStates = "trip_states"
        case tripType = "trip_type"
        case paginationRowCount = "pagination_row_count"
        case paginationOffset = "pagination_offset"
        case fleetID = "fleet_id"
        case partnerTravellerID = "partner_traveller_id"
        case partnerTripID = "partner_trip_id"
        case externalTripID = "external_trip_id"
        case displayTripID = "display_trip_id"
        case forename
        case lastname
        case email
        case createdAfter = "created_after"
        case prebookTimeAfter = "prebook_time_after"
        case prebookTimeBefore = "prebook_time_before"
        case tripTimeBefore = "trip_time_before"
        case tripTimeAfter = "trip_time_after"
        case onlyWithoutFinalPrice = "only_without_final_price"
        case orderBy = "order_by"
    }

    
    
}
