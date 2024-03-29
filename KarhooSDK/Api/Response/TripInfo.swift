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
    public let passengers: Passengers
    public var followCode: String
    public let displayId: String
    public let state: TripState
    public let vehicle: Vehicle
    public let fleetInfo: FleetInfo
    public let tripQuote: TripQuote
    public let flightNumber: String
    public let trainNumber: String
    public let trainTime: String
    public let origin: TripLocationDetails
    public let destination: TripLocationDetails?
    public let fare: TripFare
    public let costCenterReference: String
    /* The time of pick up in UTC. Use origin.timeZoneIdentifier
       to localise the pick up time for the user. */
    public let dateScheduled: Date?
    public let dateBooked: Date?

    public let meetingPoint: MeetingPoint?
    public let partnerTravellerID: String
    public let partnerTripID: String
    public let stateDetails: StateDetails?
    public let agent: Agent
    public let cancelledBy: CancelledByPayer
    public let serviceAgreements: ServiceAgreements?

    public init(tripId: String = "",
                passengers: Passengers = Passengers(),
                displayId: String = "",
                followCode: String = "",
                origin: TripLocationDetails = TripLocationDetails(),
                destination: TripLocationDetails? = nil,
                dateScheduled: Date? = nil,
                dateBooked: Date? = nil,
                state: TripState = .unknown,
                quote: TripQuote = TripQuote(),
                vehicle: Vehicle = Vehicle(),
                fleetInfo: FleetInfo = FleetInfo(),
                flightNumber: String = "",
                trainNumber: String = "",
                trainTime: String = "",
                meetingPoint: MeetingPoint? = nil,
                fare: TripFare = TripFare(),
                costCenterReference: String = "",
                partnerTravellerID: String = "",
                partnerTripID: String = "",
                stateDetails: StateDetails? = nil,
                agent: Agent = Agent(),
                cancelledBy: CancelledByPayer = CancelledByPayer(),
                serviceAgreements: ServiceAgreements? = nil) {
        self.tripId = tripId
        self.passengers = passengers
        self.displayId = displayId
        self.followCode = followCode
        self.state = state
        self.vehicle = vehicle
        self.tripQuote = quote
        self.flightNumber = flightNumber
        self.trainNumber = trainNumber
        self.trainTime = trainTime
        self.origin = origin
        self.destination = destination
        self.dateScheduled = dateScheduled
        self.dateBooked = dateBooked
        self.meetingPoint = meetingPoint
        self.fleetInfo = fleetInfo
        self.fare = fare
        self.costCenterReference = costCenterReference
        self.partnerTravellerID = partnerTravellerID
        self.partnerTripID = partnerTripID
        self.stateDetails = stateDetails
        self.agent = agent
        self.cancelledBy = cancelledBy
        self.serviceAgreements = serviceAgreements
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.tripId = (try? container.decodeIfPresent(String.self, forKey: .tripId)) ?? ""
        self.passengers = (try? container.decodeIfPresent(Passengers.self, forKey: .passengers)) ?? Passengers()
        self.followCode = (try? container.decodeIfPresent(String.self, forKey: .followCode)) ?? ""
        self.displayId = (try? container.decodeIfPresent(String.self, forKey: .displayId)) ?? ""
        self.origin = (try? container.decodeIfPresent(TripLocationDetails.self, forKey: .origin)) ?? TripLocationDetails()
        self.destination = (try? container.decodeIfPresent(TripLocationDetails.self,
                                                  forKey: .destination)) ?? TripLocationDetails()
        self.state = (try? container.decodeIfPresent(TripState.self, forKey: .state)) ?? .unknown
        self.stateDetails = (try? container.decodeIfPresent(StateDetails.self, forKey: .stateDetails)) ?? .failure
        self.tripQuote = (try? container.decodeIfPresent(TripQuote.self, forKey: .quote)) ?? TripQuote()
        self.vehicle = (try? container.decodeIfPresent(Vehicle.self, forKey: .vehicle)) ?? Vehicle()
        self.fleetInfo = (try? container.decodeIfPresent(FleetInfo.self, forKey: .fleetInfo)) ?? FleetInfo()
        self.flightNumber = (try? container.decodeIfPresent(String.self, forKey: .flightNumber)) ?? ""
        self.trainNumber = (try? container.decodeIfPresent(String.self, forKey: .trainNumber)) ?? ""
        self.trainTime = (try? container.decodeIfPresent(String.self, forKey: .trainTime)) ?? ""
        self.meetingPoint = (try? container.decodeIfPresent(MeetingPoint.self, forKey: .meetingPoint))
        self.fare = (try? container.decodeIfPresent(TripFare.self, forKey: .fare)) ?? TripFare()
        self.costCenterReference = (try? container.decodeIfPresent(String.self, forKey: .costCenterReference)) ?? ""
        self.partnerTravellerID = (try? container.decodeIfPresent(String.self, forKey: .partnerTravellerID)) ?? ""
        self.partnerTripID = (try? container.decodeIfPresent(String.self, forKey: .partnerTripID)) ?? ""
        self.agent = (try? container.decodeIfPresent(Agent.self, forKey: .agent)) ?? Agent()
        self.cancelledBy = (try? container.decodeIfPresent(CancelledByPayer.self, forKey: .cancelledBy)) ?? CancelledByPayer()
        self.serviceAgreements = (try? container.decodeIfPresent(ServiceAgreements.self, forKey: .serviceAgreements))
        
        let utcDateBooked = (try? container.decodeIfPresent(String.self, forKey: .dateBooked))
        if let utcDateBooked = utcDateBooked {
            self.dateBooked = KarhooNetworkDateFormatter(formatType: .booking).toDate(from: utcDateBooked)
        } else {
            self.dateBooked = nil
        }
        
        let utcDateScheduled = (try? container.decodeIfPresent(String.self, forKey: .dateScheduled))
        if let utcDateScheduled = utcDateScheduled {
            self.dateScheduled = KarhooNetworkDateFormatter(formatType: .booking).toDate(from: utcDateScheduled)
        } else {
            self.dateScheduled = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(tripId, forKey: .tripId)
        try container.encode(passengers, forKey: .passengers)
        try container.encode(followCode, forKey: .followCode)
        try container.encode(displayId, forKey: .displayId)
        try container.encode(dateScheduled, forKey: .dateScheduled)
        try container.encode(dateBooked, forKey: .dateBooked)
        try container.encode(origin, forKey: .origin)
        try container.encode(destination, forKey: .destination)
        try container.encode(state, forKey: .state)
        try container.encode(stateDetails, forKey: .stateDetails)
        try container.encode(tripQuote, forKey: .quote)
        try container.encode(vehicle, forKey: .vehicle)
        try container.encode(fleetInfo, forKey: .fleetInfo)
        try container.encode(flightNumber, forKey: .flightNumber)
        try container.encode(trainNumber, forKey: .trainNumber)
        try container.encode(trainTime, forKey: .trainTime)
        try container.encode(meetingPoint, forKey: .meetingPoint)
        try container.encode(fare, forKey: .fare)
        try container.encode(costCenterReference, forKey: .costCenterReference)
        try container.encode(partnerTravellerID, forKey: .partnerTravellerID)
        try container.encode(partnerTripID, forKey: .partnerTripID)
        try container.encode(agent, forKey: .agent)
        try container.encode(cancelledBy, forKey: .cancelledBy)
        try container.encode(serviceAgreements, forKey: .serviceAgreements)
    }
    
    enum CodingKeys: String, CodingKey {
        case tripId = "id"
        case passengers
        case displayId = "display_trip_id"
        case followCode = "follow_code"
        case state = "status"
        case stateDetails = "state_details"
        case origin
        case destination = "destination"
        case dateScheduled = "date_scheduled"
        case dateBooked = "date_booked"
        case vehicle
        case quote
        case fleetInfo = "fleet_info"
        case meetingPoint = "meeting_point"
        case flightNumber = "flight_number"
        case trainNumber = "train_number"
        case trainTime = "train_time"
        case fare
        case costCenterReference = "cost_center_reference"
        case partnerTravellerID = "partner_traveller_id "
        case partnerTripID = "partner_trip_id"
        case agent
        case cancelledBy = "cancelled_by"
        case serviceAgreements = "service_level_agreements"
    }
}
