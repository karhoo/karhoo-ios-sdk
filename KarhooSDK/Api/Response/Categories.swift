//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Categories: KarhooCodableModel, Equatable {

    public let categories: [String]

    public init(categories: [String] = []) {
        self.categories = categories
    }

    enum CodingKeys: String, CodingKey {
        case categories
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.categories = (try? container.decode([String].self, forKey: .categories)) ?? []
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(categories, forKey: .categories)
    }
}
