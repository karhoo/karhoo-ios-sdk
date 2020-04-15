//
//  QuoteCategory.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct QuoteCategory: KarhooCodableModel, Equatable {
    public let categoryName: String
    public let quotes: [Quote]

    public init(name: String = "",
                quotes: [Quote] = []) {
        self.categoryName = name
        self.quotes = quotes
    }
}
