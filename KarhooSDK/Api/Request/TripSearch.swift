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

    enum CodingKeys: String, CodingKey {
        case tripStates = "trip_states"
        case tripType = "trip_type"
        case paginationRowCount = "pagination_row_count"
        case paginationOffset = "pagination_offset"
    }

    public init(tripStates: [TripState]? = nil,
                tripType: TripType? = .both,
                paginationRowCount: Int? = nil,
                paginationOffset: Int? = nil) {
        self.tripStates = tripStates
        self.tripType = tripType
        self.paginationRowCount = paginationRowCount
        self.paginationOffset = paginationOffset
    }
}
