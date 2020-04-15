//
//  CategoryQuoteMapper.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

struct CategoryQuoteMapper {

    func map(categories: Categories?, toQuotes quotes: [Quote]) -> [QuoteCategory] {
        let categoryKeysForMapping = (categories?.categories ?? quotes.map { $0.categoryName }).uniqueArray()

        return categoryKeysForMapping.map { category in
            let quotes = quotes.filter { $0.categoryName.lowercased() == category.lowercased() }
            return QuoteCategory(name: category,
                                 quotes: quotes)
        }
    }
}

fileprivate extension Array where Element: Equatable {
    func uniqueArray() -> [Element] {
        var newArray: [Element] = []
        for item in self {
            if newArray.contains(item) == false {
                newArray.append(item)
            }
        }
        return newArray
    }
}
