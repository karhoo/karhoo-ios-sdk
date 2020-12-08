//
//  TripCancellation.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct TripCancellation {

    public let tripId: String
    public let cancelReason: CancelReason
    public let explanation: String

    public init(tripId: String = "",
                cancelReason: CancelReason = .otherUserReason,
                explanation: String = "") {
        self.tripId = tripId
        self.cancelReason = cancelReason
        self.explanation = explanation
    }
}
