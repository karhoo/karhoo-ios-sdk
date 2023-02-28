//
//  LocationInfoAddress.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct LocationInfoAddress: KarhooCodableModel {

    public let displayAddress: String
    public let lineOne: String
    public let lineTwo: String
    public let buildingNumber: String
    public let streetName: String
    public let city: String
    public let postalCode: String
    public let region: String
    public let countryCode: String

    public init(displayAddress: String = "",
                lineOne: String = "",
                lineTwo: String = "",
                buildingNumber: String = "",
                streetName: String = "",
                city: String = "",
                postalCode: String = "",
                countryCode: String = "",
                region: String = "") {
        self.displayAddress = displayAddress
        self.lineOne = lineOne
        self.lineTwo = lineTwo
        self.buildingNumber = buildingNumber
        self.streetName = streetName
        self.city = city
        self.postalCode = postalCode
        self.region = region
        self.countryCode = countryCode
    }

    enum CodingKeys: String, CodingKey {
        case displayAddress = "display_address"
        case lineOne = "line_1"
        case lineTwo = "line_2"
        case buildingNumber = "building_number"
        case streetName = "street_name"
        case city
        case postalCode = "postal_code"
        case region
        case countryCode = "country_code"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.displayAddress = (try? container.decodeIfPresent(String.self, forKey: .displayAddress)) ?? ""
        self.lineOne = (try? container.decodeIfPresent(String.self, forKey: .lineOne)) ?? ""
        self.lineTwo = (try? container.decodeIfPresent(String.self, forKey: .lineTwo)) ?? ""
        self.buildingNumber = (try? container.decodeIfPresent(String.self, forKey: .buildingNumber)) ?? ""
        self.streetName = (try? container.decodeIfPresent(String.self, forKey: .streetName)) ?? ""
        self.city = (try? container.decodeIfPresent(String.self, forKey: .city)) ?? ""
        self.postalCode = (try? container.decodeIfPresent(String.self, forKey: .postalCode)) ?? ""
        self.region = (try? container.decodeIfPresent(String.self, forKey: .region)) ?? ""
        self.countryCode = (try? container.decodeIfPresent(String.self, forKey: .countryCode)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(displayAddress, forKey: .displayAddress)
        try container.encode(lineOne, forKey: .lineOne)
        try container.encode(lineTwo, forKey: .lineTwo)
        try container.encode(buildingNumber, forKey: .buildingNumber)
        try container.encode(streetName, forKey: .streetName)
        try container.encode(city, forKey: .city)
        try container.encode(postalCode, forKey: .postalCode)
        try container.encode(region, forKey: .region)
        try container.encode(countryCode, forKey: .countryCode)
    }
}
