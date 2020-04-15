//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

class CategoriesMock {
    private var categories: Categories

    init() {
        self.categories = Categories(categories: [])
    }

    func set(categories: [String]) -> CategoriesMock {
        self.categories = Categories(categories: categories)
        return self
    }

    func build() -> Categories {
        return categories
    }
}
