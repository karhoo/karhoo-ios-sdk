//
//  MockQuoteInteractorV2.swift
//  KarhooSDKTests
//
//  Created by Jo Santamaria on 28/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockQuoteInteractorV2: QuoteInteractor, MockInteractor {

    var cancelCalled: Bool = false
    var callbackSet: CallbackClosure<Quotes>?

    var quoteSearchSet: QuoteSearch?
    func set(quoteSearch: QuoteSearch) {
        self.quoteSearchSet = quoteSearch
    }
}
