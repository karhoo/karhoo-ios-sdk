//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

struct QuoteListId: KarhooCodableModel {

    public let identifier: String
    public let validityTime: Int

    init(identifier: String, validityTime: Int) {
        self.identifier = identifier
        self.validityTime = validityTime
    }

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case validityTime = "validity"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = (try? container.decode(String.self, forKey: .identifier)) ?? ""
        self.validityTime = (try? container.decode(Int.self, forKey: .validityTime)) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(validityTime, forKey: .validityTime)
    }
}
