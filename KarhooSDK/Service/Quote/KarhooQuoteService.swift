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
    private let coverageInteractor: QuoteCoverageInteractor

    init(quoteInteractor: QuoteInteractor = KarhooQuoteInteractor(),
         coverageInteractor: QuoteCoverageInteractor = KarhooQuoteCoverageInteractor()) {
        self.quoteInteractor = quoteInteractor
        self.coverageInteractor = coverageInteractor
    }

    func quotes(quoteSearch: QuoteSearch) -> PollCall<Quotes> {
        quoteInteractor.set(quoteSearch: quoteSearch)
        let pollExecutor = PollExecutor(executable: quoteInteractor)
        return PollCall(pollExecutor: pollExecutor)
    }
    
    func coverage(coverageRequest: QuoteCoverageRequest) -> Call<QuoteCoverage> {
        coverageInteractor.set(coverageRequest: coverageRequest)
        return Call(executable: coverageInteractor)
    }
}
