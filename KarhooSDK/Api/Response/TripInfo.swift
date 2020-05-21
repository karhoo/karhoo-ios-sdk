//
//  TripInfo.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct TripInfo: KarhooCodableModel {

    public let tripId: String
    public var followCode: String
    public let displayId: String
    public let state: TripState
    public let vehicle: Vehicle
    public let fleetInfo: FleetInfo
    public let tripQuote: TripQuote
    public let flightNumber: String
    public let origin: TripLocationDetails
    public let destination: TripLocationDetails?
    public let fare: TripFare
    /* The time of pick up in UTC. Use origin.timeZoneIdentifier
       to localise the pick up time for the user. */
    public let dateScheduled: Date?

    public let meetingPoint: MeetingPoint?

    public init(tripId: String = "",
                displayId: String = "",
                followCode: String = "",
                origin: TripLocationDetails = TripLocationDetails(),
                destination: TripLocationDetails? = nil,
                dateScheduled: Date? = nil,
                state: TripState = .unknown,
                quote: TripQuote = TripQuote(),
                vehicle: Vehicle = Vehicle(),
                fleetInfo: FleetInfo = FleetInfo(),
                flightNumber: String = "",
                meetingPoint: MeetingPoint? = nil,
                fare: TripFare = TripFare()) {
        self.tripId = tripId
        self.displayId = displayId
        self.followCode = followCode
        self.state = state
        self.vehicle = vehicle
        self.tripQuote = quote
        self.flightNumber = flightNumber
        self.origin = origin
        self.destination = destination
        self.dateScheduled = dateScheduled
        self.meetingPoint = meetingPoint
        self.fleetInfo = fleetInfo
        self.fare = fare
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.tripId = (try? container.decode(String.self, forKey: .tripId)) ?? ""
        self.followCode = (try? container.decode(String.self, forKey: .followCode)) ?? ""
        self.displayId = (try? container.decode(String.self, forKey: .displayId)) ?? ""
        self.origin = (try? container.decode(TripLocationDetails.self, forKey: .origin)) ?? TripLocationDetails()
        self.destination = (try? container.decode(TripLocationDetails.self,
                                                  forKey: .destination)) ?? TripLocationDetails()
        self.state = (try? container.decode(TripState.self, forKey: .state)) ?? .unknown
        self.tripQuote = (try? container.decode(TripQuote.self, forKey: .quote)) ?? TripQuote()
        self.vehicle = (try? container.decode(Vehicle.self, forKey: .vehicle)) ?? Vehicle()
        self.fleetInfo = (try? container.decode(FleetInfo.self, forKey: .fleetInfo)) ?? FleetInfo()
        self.flightNumber = (try? container.decode(String.self, forKey: .flightNumber)) ?? ""
        self.meetingPoint = (try? container.decode(MeetingPoint.self, forKey: .meetingPoint))
        self.fare = (try? container.decode(TripFare.self, forKey: .fare)) ?? TripFare()
        
        let utcDate = (try? container.decode(String.self, forKey: .dateScheduled))

        if let utcDate = utcDate {
            self.dateScheduled = KarhooNetworkDateFormatter(formatType: .booking).toDate(from: utcDate)
        } else {
            self.dateScheduled = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(tripId, forKey: .tripId)
        try container.encode(followCode, forKey: .followCode)
        try container.encode(displayId, forKey: .displayId)
        try container.encode(dateScheduled, forKey: .dateScheduled)
        try container.encode(origin, forKey: .origin)
        try container.encode(destination, forKey: .destination)
        try container.encode(state, forKey: .state)
        try container.encode(tripQuote, forKey: .quote)
        try container.encode(vehicle, forKey: .vehicle)
        try container.encode(fleetInfo, forKey: .fleetInfo)
        try container.encode(flightNumber, forKey: .flightNumber)
        try container.encode(meetingPoint, forKey: .meetingPoint)
        try container.encode(fare, forKey: .fare)
    }
    
    enum CodingKeys: String, CodingKey {
        case tripId = "id"
        case displayId = "display_trip_id"
        case followCode = "follow_code"
        case state = "status"
        case origin
        case destination = "destination"
        case dateScheduled = "date_scheduled"
        case vehicle
        case quote
        case fleetInfo = "fleet_info"
        case meetingPoint = "meeting_point"
        case flightNumber = "flight_number"
        case fare
    }
}
