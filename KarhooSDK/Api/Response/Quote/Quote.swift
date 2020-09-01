//
//  Quote.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Quote: KarhooCodableModel, Equatable {

    public let vehicleAttributes: VehicleAttributes
    public let validity: Int
    public let id: String
    public let quoteType: QuoteType
    public let pickUpType: PickUpType
    public let source: QuoteSource
    public let fleet: FleetInfo
    public let vehicle: QuoteVehicle
    public let price: QuotePrice

    public init(id: String = "",
                quoteType: QuoteType = .estimated,
                source: QuoteSource = .fleet,
                pickUpType: PickUpType = .default,
                fleet: FleetInfo = FleetInfo(),
                vehicleAttributes: VehicleAttributes = VehicleAttributes(),
                vehicle: QuoteVehicle = QuoteVehicle(),
                price: QuotePrice = QuotePrice(),
                validity: Int = 0) {
        self.id = id
        self.fleet = fleet
        self.quoteType = quoteType
        self.pickUpType = pickUpType
        self.source = source
        self.vehicleAttributes = vehicleAttributes
        self.vehicle = vehicle
        self.validity = validity
        self.price = price
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case fleet
        case quoteType = "quote_type"
        case pickUpType = "pick_up_type"
        case source
        case vehicleAttributes = "vehicle_attributes"
        case vehicle
        case validity
        case price
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.quoteType = (try? container.decode(QuoteType.self, forKey: .quoteType)) ?? .estimated
        self.pickUpType = (try? container.decode(PickUpType.self, forKey: .pickUpType)) ?? .default
        self.source = (try? container.decode(QuoteSource.self, forKey: .source)) ?? .fleet
        self.vehicleAttributes = (try? container.decode(VehicleAttributes.self, forKey: .vehicleAttributes)) ?? VehicleAttributes()

        self.id = (try? container.decode(String.self, forKey: .id)) ?? ""
        self.fleet = (try? container.decode(FleetInfo.self, forKey: .fleet)) ?? FleetInfo()
        self.vehicle = (try? container.decode(QuoteVehicle.self, forKey: .vehicle)) ?? QuoteVehicle()
        self.validity = (try? container.decode(Int.self, forKey: .validity)) ?? 0
        self.price = (try? container.decode(QuotePrice.self, forKey: .price)) ?? QuotePrice()
    }

    public static func == (lhs: Quote, rhs: Quote) -> Bool {
        return lhs.id == rhs.id
    }
}
