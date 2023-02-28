//
//  Quote.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Quote: KarhooCodableModel, Equatable {

    public let validity: Int
    public let id: String
    public let quoteType: QuoteType
    public let pickUpType: PickUpType
    public let source: QuoteSource
    public let fleet: Fleet
    public let vehicle: QuoteVehicle
    public let price: QuotePrice
    public let serviceLevelAgreements: ServiceAgreements?

    public init(id: String = "",
                quoteType: QuoteType = .estimated,
                source: QuoteSource = .fleet,
                pickUpType: PickUpType = .default,
                fleet: Fleet = Fleet(),
                vehicle: QuoteVehicle = QuoteVehicle(),
                price: QuotePrice = QuotePrice(),
                validity: Int = 0,
                serviceLevelAgreements: ServiceAgreements = ServiceAgreements()) {
        self.id = id
        self.fleet = fleet
        self.quoteType = quoteType
        self.pickUpType = pickUpType
        self.source = source
        self.vehicle = vehicle
        self.validity = validity
        self.price = price
        self.serviceLevelAgreements = serviceLevelAgreements
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case fleet
        case quoteType = "quote_type"
        case pickUpType = "pick_up_type"
        case source
        case vehicle
        case validity
        case price
        case serviceLevelAgreements = "service_level_agreements"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.quoteType = (try? container.decodeIfPresent(QuoteType.self, forKey: .quoteType)) ?? .estimated
        self.pickUpType = (try? container.decodeIfPresent(PickUpType.self, forKey: .pickUpType)) ?? .default
        self.source = (try? container.decodeIfPresent(QuoteSource.self, forKey: .source)) ?? .fleet

        self.id = (try? container.decodeIfPresent(String.self, forKey: .id)) ?? ""
        self.fleet = (try? container.decodeIfPresent(Fleet.self, forKey: .fleet)) ?? Fleet()
        self.vehicle = (try? container.decodeIfPresent(QuoteVehicle.self, forKey: .vehicle)) ?? QuoteVehicle()
        self.validity = (try? container.decodeIfPresent(Int.self, forKey: .validity)) ?? 0
        self.price = (try? container.decodeIfPresent(QuotePrice.self, forKey: .price)) ?? QuotePrice()
        self.serviceLevelAgreements = (try? container.decodeIfPresent(ServiceAgreements.self, forKey: .serviceLevelAgreements))
    }

    public static func == (lhs: Quote, rhs: Quote) -> Bool {
        return lhs.id == rhs.id
    }
}
