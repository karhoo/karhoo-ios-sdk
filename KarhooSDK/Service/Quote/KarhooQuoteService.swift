//
//  KarhooQuoteService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooQuoteService: QuoteService {

    private let quoteInteractorV2: QuoteInteractor

    init(quoteV2Interactor: QuoteInteractor = KarhooQuoteInteractor()) {
        self.quoteInteractorV2 = quoteV2Interactor
    }

    func quotesV2(quoteSearch: QuoteSearch) -> PollCall<Quotes> {
        quoteInteractorV2.set(quoteSearch: quoteSearch)
        let pollExecutor = PollExecutor(executable: quoteInteractorV2)
        return PollCall(pollExecutor: pollExecutor)
    }
}
