//
//  KarhooQuoteService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooQuoteService: QuoteService {

    private let quoteInteractor: QuoteInteractor
    private let quoteInteractorV2: QuoteInteractor

    init(quoteInteractor: QuoteInteractor = KarhooQuoteInteractor(), quoteV2Interactor: QuoteInteractor = KarhooQuoteInteractorV2()) {
        self.quoteInteractor = quoteInteractor
        self.quoteInteractorV2 = quoteInteractor
    }

    @available(*, deprecated, message: "use quotes (QuotesV2)")
    func quotes(quoteSearch: QuoteSearch) -> PollCall<Quotes> {
        quoteInteractor.set(quoteSearch: quoteSearch)
        let pollExecutor = PollExecutor(executable: quoteInteractor)
        return PollCall(pollExecutor: pollExecutor)
    }
    
    func quotesV2(quoteSearch: QuoteSearch) -> PollCall<Quotes> {
        quoteInteractorV2.set(quoteSearch: quoteSearch)
        let pollExecutor = PollExecutor(executable: quoteInteractorV2)
        return PollCall(pollExecutor: pollExecutor)
    }
}
