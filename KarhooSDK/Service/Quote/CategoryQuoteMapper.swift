//
//  CategoryQuoteMapper.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

struct CategoryQuoteMapper {

    func map(categories: [String], toQuotes quotes: [Quote]) -> [QuoteCategory] {
        var categoriesToMap: [String] = categories.uniqueArray()

        if categories.isEmpty {
            categoriesToMap = quotes.map { $0.vehicle.type }.uniqueArray()
        }

        return categoriesToMap.map { category in
            let quotes = quotes.filter {
                let name = $0.vehicle.type
                return name.lowercased() == category.lowercased()
            }
            
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
