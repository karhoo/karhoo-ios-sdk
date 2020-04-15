//
//  MockQuoteInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockQuoteInteractor: QuoteInteractor, MockInteractor {

    var cancelCalled: Bool = false
    var callbackSet: CallbackClosure<Quotes>?

    var quoteSearchSet: QuoteSearch?
    func set(quoteSearch: QuoteSearch) {
        self.quoteSearchSet = quoteSearch
    }
}
