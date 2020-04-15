//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

class QuoteIdMock {

    private var quoteId: QuoteListId

    init() {
        self.quoteId = QuoteListId(identifier: "", validityTime: 0)
    }

    func set(quoteId: String, validityTime: Int = 0) -> QuoteIdMock {
        self.quoteId = QuoteListId(identifier: quoteId,
                                   validityTime: validityTime)
        return self
    }

    func build() -> QuoteListId {
        return quoteId
    }
}
