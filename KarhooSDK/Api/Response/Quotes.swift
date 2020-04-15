//
//  Quotes.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Quotes: KarhooCodableModel {

    public let quoteListId: String
    public let quoteCategories: [QuoteCategory]
    public let all: [Quote]

    public func quotes(for category: String) -> [Quote] {
        return quoteCategories.filter { $0.categoryName == category }.first?.quotes ?? []
    }

    public init(quoteListId: String = "",
                quoteCategories: [QuoteCategory] = [],
                all: [Quote] = []) {
        self.quoteCategories = quoteCategories
        self.all = all
        self.quoteListId = quoteListId
    }
}
