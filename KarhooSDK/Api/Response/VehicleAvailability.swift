//
//  VehicleAvailability.swift
//  KarhooSDK
//
//  Created by Jeevan Thandi on 15/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct VehicleAvailability: KarhooCodableModel {

    public let classes: [String]

    public init(classes: [String] = []) {
        self.classes = classes
    }

    enum CodingKeys: String, CodingKey {
        case classes
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.classes = (try? container.decode(Array.self, forKey: .classes)) ?? []
    }
}
