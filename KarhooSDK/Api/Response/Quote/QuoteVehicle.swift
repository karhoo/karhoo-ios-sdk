//
//  QuoteVehicle.swift
//  KarhooSDK
//
//  Created by Jeevan Thandi on 16/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct QuoteVehicle: Codable {

    public let vehicleClass: String
    public let qta: QuoteQta


    public init(vehicleClass: String = "",
                qta: QuoteQta = QuoteQta()) {
        self.vehicleClass = vehicleClass
        self.qta = qta
    }

    enum CodingKeys: String, CodingKey {
        case vehicleClass = "class"
        case qta
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.vehicleClass = (try? container.decode(String.self, forKey: .vehicleClass)) ?? ""
        self.qta = (try? container.decode(QuoteQta.self, forKey: .qta)) ?? QuoteQta()
    }
}
