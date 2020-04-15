//
//  Quote.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Quote: KarhooCodableModel, Equatable {

    public let quoteId: String
    public let fleetId: String
    public let availabilityId: String
    public let phoneNumber: String
    public let fleetName: String
    public let supplierLogoUrl: String
    public let vehicleClass: String
    public let quoteType: QuoteType
    public let highPrice: Double
    public let lowPrice: Double
    public let currencyCode: String
    public let qtaHighMinutes: Int
    public let qtaLowMinutes: Int
    public let termsConditionsUrl: String
    public let categoryName: String
    public let pickUpType: PickUpType
    public let source: QuoteSource
    public let vehicleAttributes: VehicleAttributes

    public init(quoteId: String = "",
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
                vehicleAttributes: VehicleAttributes = VehicleAttributes()) {
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
    }

    enum CodingKeys: String, CodingKey {
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
    }

    public static func == (lhs: Quote, rhs: Quote) -> Bool {
        return lhs.quoteId == rhs.quoteId
    }
}
