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

    init(quoteInteractor: QuoteInteractor = KarhooQuoteInteractor()) {
        self.quoteInteractor = quoteInteractor
    }

    func quotes(quoteSearch: QuoteSearch) -> PollCall<Quotes> {
        quoteInteractor.set(quoteSearch: quoteSearch)
        let pollExecutor = PollExecutor(executable: quoteInteractor)
        return PollCall(pollExecutor: pollExecutor)
    }
}
