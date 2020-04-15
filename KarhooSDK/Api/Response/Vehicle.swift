//
//  Vehicle.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Vehicle: Codable {

    public let vehicleClass: String
    public let vehicleLicensePlate: String
    public let description: String
    public let driver: Driver

    public init(vehicleClass: String = "",
                vehicleLicensePlate: String = "",
                description: String = "",
                driver: Driver = Driver()) {
        self.vehicleClass = vehicleClass
        self.vehicleLicensePlate = vehicleLicensePlate
        self.description = description
        self.driver = driver
    }

    enum CodingKeys: String, CodingKey {
        case vehicleClass = "vehicle_class"
        case vehicleLicensePlate = "vehicle_license_plate"
        case driver
        case description
    }
}
