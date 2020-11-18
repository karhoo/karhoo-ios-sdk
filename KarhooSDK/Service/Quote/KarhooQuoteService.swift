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
    private let verifyQuoteInteractor: VerifyQuoteInteractor

    init(quoteInteractor: QuoteInteractor = KarhooQuoteInteractor(),
         coverageInteractor: QuoteCoverageInteractor = KarhooQuoteCoverageInteractor(),
         verifyQuoteInteractor: VerifyQuoteInteractor = KarhooVerifyQuoteInteractor()) {
        self.quoteInteractor = quoteInteractor
        self.coverageInteractor = coverageInteractor
        self.verifyQuoteInteractor = verifyQuoteInteractor
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
    
    func verifyQuote(verifyQuotePayload: VerifyQuotePayload) -> Call<Quote> {
        verifyQuoteInteractor.set(verifyQuotePayload: verifyQuotePayload)
        return Call(executable: verifyQuoteInteractor)
    }
}
