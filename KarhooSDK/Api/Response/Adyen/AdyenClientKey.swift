//
// Created by Bartlomiej Sopala on 06/04/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenClientKey: KarhooCodableModel {

    public let clientKey: String
    public let environment: String

    public init(clientKey: String = "", environment: String = "") {
        self.clientKey = clientKey
        self.environment = environment
    }

    enum CodingKeys: String, CodingKey {
        case clientKey, environment
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clientKey = (try? container.decodeIfPresent(String.self, forKey: .clientKey)) ?? ""
        environment = (try? container.decodeIfPresent(String.self, forKey: .environment)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(clientKey, forKey: .clientKey)
        try container.encode(environment, forKey: .environment)
    }
}