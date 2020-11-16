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
    public let type: String
    public let tags: [String]
    public let qta: QuoteQta


    public init(vehicleClass: String = "",
                type: String = "",
                tags: [String] = [],
                qta: QuoteQta = QuoteQta()) {
        self.vehicleClass = vehicleClass
        self.type = type
        self.tags = tags
        self.qta = qta
    }

    enum CodingKeys: String, CodingKey {
        case vehicleClass = "class"
        case type
        case tags
        case qta
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.vehicleClass = (try? container.decode(String.self, forKey: .vehicleClass)) ?? ""
        self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
        self.tags = (try? container.decode(Array.self, forKey: .tags)) ?? []
        self.qta = (try? container.decode(QuoteQta.self, forKey: .qta)) ?? QuoteQta()
    }
}
