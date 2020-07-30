//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

typealias QuoteListKeys = QuoteList.CodingKeys

public struct QuoteList: KarhooCodableModel {

    @available(*, deprecated, message: "use quotes (QuotesV2)")
    public let quoteItems: [Quote]

    public let quotes: [Quote]
    public let listId: String
    public let status: String
    let validity: Int
    public let availability: Availability

    internal init(quoteItems: [Quote] = [],
                  quotes: [Quote] = [],
                  listId: String = "",
                  status: String = "",
                  validity: Int = 0,
                  availability: Availability = Availability()) {
        self.quoteItems = quoteItems
        self.listId = listId
        self.status = status
        self.validity = validity
        self.availability = availability
        self.quotes = quotes
    }

    enum CodingKeys: String, CodingKey {
        case quoteItems = "quote_items"
        case quotes
        case listId = "id"
        case status
        case validity
        case availability
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.quoteItems = (try? container.decode([Quote].self, forKey: .quoteItems)) ?? []
        self.quotes = (try? container.decode([Quote].self, forKey: .quotes)) ?? []
        self.listId = try container.decode(String.self, forKey: .listId)
        self.status = (try? container.decode(String.self, forKey: .status)) ?? ""
        self.validity = (try? container.decode(Int.self, forKey: .validity)) ?? 0
        self.availability = (try? container.decode(Availability.self, forKey: .availability)) ?? Availability()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(quoteItems, forKey: .quoteItems)
        try container.encode(listId, forKey: .listId)
        try container.encode(status, forKey: .status)
        try container.encode(validity, forKey: .validity)
    }
}
