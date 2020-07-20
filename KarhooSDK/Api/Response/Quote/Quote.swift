//
//  Quote.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Quote: KarhooCodableModel, Equatable {

    @available(*, deprecated, message: "use id (QuotesV2)")
    public let quoteId: String

    @available(*, deprecated, message: "use fleet.id (QuotesV2)")
    public let fleetId: String

    @available(*, deprecated, message: "use not supported (QuotesV2)")
    public let availabilityId: String

    @available(*, deprecated, message: "use fleet.phoneNumber (QuotesV2)")
    public let phoneNumber: String

    @available(*, deprecated, message: "use fleet.name (QuotesV2)")
    public let fleetName: String

    @available(*, deprecated, message: "use fleet.supplierLogoUrl (QuotesV2)")
    public let supplierLogoUrl: String

    @available(*, deprecated, message: "use fleet.termsConditionsUrl (QuotesV2)")
    public let termsConditionsUrl: String

    @available(*, deprecated, message: "use vehicle.vehicleClass (QuotesV2)")
    public let vehicleClass: String

    @available(*, deprecated, message: "use price.highPrice (QuotesV2)")
    public let highPrice: Double

    @available(*, deprecated, message: "use price.lowPrice (QuotesV2)")
    public let lowPrice: Double

    @available(*, deprecated, message: "use price.currencyCode (QuotesV2)")
    public let currencyCode: String

    @available(*, deprecated, message: "use vehicle.qta.qtaHighMinutes (QuotesV2)")
    public let qtaHighMinutes: Int

    @available(*, deprecated, message: "use vehicle.qta.qtaHighMinutes (QuotesV2)")
    public let qtaLowMinutes: Int

    @available(*, deprecated, message: "use vehicle.vehicleClass (QuotesV2)")
    public let categoryName: String


    public let vehicleAttributes: VehicleAttributes
    public let validity: Int

    // v2
    public let id: String
    public let quoteType: QuoteType
    public let pickUpType: PickUpType
    public let source: QuoteSource
    public let fleet: FleetInfo
    public let vehicle: QuoteVehicle

    public init(id: String = "",
                quoteId: String = "",
                fleetId: String = "",
                availabilityId: String = "",
                fleetName: String = "",
                phoneNumber: String = "",
                supplierLogoUrl: String = "",
                vehicleClass: String = "",
                quoteType: QuoteType = .estimated,
                highPrice: Int = 0,
                lowPrice: Int = 0,
                currencyCode: String = "",
                qtaHighMinutes: Int = 0,
                qtaLowMinutes: Int = 0,
                termsConditionsURL: String = "",
                categoryName: String = "",
                source: QuoteSource = .fleet,
                pickUpType: PickUpType = .default,
                fleet: FleetInfo = FleetInfo(),
                vehicleAttributes: VehicleAttributes = VehicleAttributes(),
                vehicle: QuoteVehicle = QuoteVehicle(),
                validity: Int = 0) {
        self.id = id
        self.fleet = fleet
        self.quoteId = quoteId
        self.fleetId = fleetId
        self.availabilityId = availabilityId
        self.fleetName = fleetName
        self.phoneNumber = phoneNumber
        self.supplierLogoUrl = supplierLogoUrl
        self.vehicleClass = vehicleClass
        self.quoteType = quoteType
        self.highPrice = Double(highPrice)*0.01
        self.lowPrice = Double(lowPrice)*0.01
        self.currencyCode = currencyCode
        self.qtaHighMinutes = qtaHighMinutes
        self.qtaLowMinutes = qtaLowMinutes
        self.termsConditionsUrl = termsConditionsURL
        self.categoryName = categoryName
        self.pickUpType = pickUpType
        self.source = source
        self.vehicleAttributes = vehicleAttributes
        self.vehicle = vehicle
        self.validity = validity
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case fleet
        case quoteId = "quote_id"
        case fleetId = "fleet_id"
        case availabilityId = "availability_id"
        case fleetName = "fleet_name"
        case phoneNumber = "phone_number"
        case supplierLogoUrl = "supplier_logo_url"
        case vehicleClass = "vehicle_class"
        case quoteType = "quote_type"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case currencyCode = "currency_code"
        case qtaHighMinutes = "qta_high_minutes"
        case qtaLowMinutes = "qta_low_minutes"
        case termsConditionsUrl = "terms_conditions_url"
        case categoryName = "category_name"
        case pickUpType = "pick_up_type"
        case source
        case vehicleAttributes = "vehicle_attributes"
        case vehicle
        case validity
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.quoteId = (try? container.decode(String.self, forKey: .quoteId)) ?? ""
        self.fleetId = (try? container.decode(String.self, forKey: .fleetId)) ?? ""
        self.availabilityId = (try? container.decode(String.self, forKey: .availabilityId)) ?? ""
        self.fleetName = (try? container.decode(String.self, forKey: .fleetName)) ?? ""
        self.phoneNumber = (try? container.decode(String.self, forKey: .phoneNumber)) ?? ""
        self.supplierLogoUrl = (try? container.decode(String.self, forKey: .supplierLogoUrl)) ?? ""
        self.vehicleClass = (try? container.decode(String.self, forKey: .vehicleClass)) ?? ""
        self.quoteType = (try? container.decode(QuoteType.self, forKey: .quoteType)) ?? .estimated
        let intHighPrice: Int = (try? container.decode(Int.self, forKey: .highPrice)) ?? 0
        self.highPrice = Double(intHighPrice) * 0.01
        let intLowPrice: Int = (try? container.decode(Int.self, forKey: .lowPrice)) ?? 0
        self.lowPrice = Double(intLowPrice) * 0.01
        self.currencyCode = (try? container.decode(String.self, forKey: .currencyCode)) ?? ""
        self.qtaHighMinutes = (try? container.decode(Int.self, forKey: .qtaHighMinutes)) ?? 0
        self.qtaLowMinutes = (try? container.decode(Int.self, forKey: .qtaLowMinutes)) ?? 0
        self.termsConditionsUrl = (try? container.decode(String.self, forKey: .termsConditionsUrl)) ?? ""
        self.categoryName = (try? container.decode(String.self, forKey: .categoryName)) ?? ""
        self.pickUpType = (try? container.decode(PickUpType.self, forKey: .pickUpType)) ?? .default
        self.source = (try? container.decode(QuoteSource.self, forKey: .source)) ?? .fleet
        self.vehicleAttributes = (try? container.decode(VehicleAttributes.self, forKey: .vehicleAttributes)) ?? VehicleAttributes()

        self.id = (try? container.decode(String.self, forKey: .id)) ?? ""
        self.fleet = (try? container.decode(FleetInfo.self, forKey: .fleet)) ?? FleetInfo()
        self.vehicle = (try? container.decode(QuoteVehicle.self, forKey: .vehicle)) ?? QuoteVehicle()
        self.validity = (try? container.decode(Int.self, forKey: .validity)) ?? 0
    }

    public static func == (lhs: Quote, rhs: Quote) -> Bool {
        return lhs.quoteId == rhs.quoteId || lhs.id == rhs.id
    }
}
