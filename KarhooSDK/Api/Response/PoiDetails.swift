//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct PoiDetails: Codable {
    public let iata: String
    public let terminal: String
    public let type: PoiDetailsType

    public init(iata: String = "",
                terminal: String = "",
                type: PoiDetailsType = .notSetDetailsType) {
        self.iata = iata
        self.terminal = terminal
        self.type = type
    }

    enum CodingKeys: String, CodingKey {
        case iata
        case terminal
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.iata = (try? container.decode(String.self, forKey: .iata)) ?? ""
        self.terminal = (try? container.decode(String.self, forKey: .terminal)) ?? ""
        self.type = (try? container.decode(PoiDetailsType.self, forKey: .type)) ?? .notSetDetailsType
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(iata, forKey: .iata)
        try container.encode(terminal, forKey: .terminal)
        try container.encode(type, forKey: .type)
    }
}
