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
    private let coverageInteractor: CoverageInteractor

    init(quoteInteractor: QuoteInteractor = KarhooQuoteInteractor(),
         coverageInteractor: CoverageInteractor = KarhooCoverageInteractor()) {
        self.quoteInteractor = quoteInteractor
        self.coverageInteractor = coverageInteractor
    }

    func quotes(quoteSearch: QuoteSearch) -> PollCall<Quotes> {
        quoteInteractor.set(quoteSearch: quoteSearch)
        let pollExecutor = PollExecutor(executable: quoteInteractor)
        return PollCall(pollExecutor: pollExecutor)
    }
    
    func coverage(coverageRequest: CoverageRequest) -> Call<Coverage> {
        coverageInteractor.set(coverageRequest: coverageRequest)
        return Call(executable: coverageInteractor)
    }
}
