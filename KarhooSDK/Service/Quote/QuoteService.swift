//
//  QuoteService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol QuoteService {    
    func quotes(quoteSearch: QuoteSearch, locale: String?) -> PollCall<Quotes>
    func coverage(coverageRequest: QuoteCoverageRequest) -> Call<QuoteCoverage>
    func verifyQuote(verifyQuotePayload: VerifyQuotePayload) -> Call<Quote>
    func getVehicleImageRules() -> Call<VehicleImageRules>
}

public extension QuoteService {
    func quotes(quoteSearch: QuoteSearch, locale: String? = nil) -> PollCall<Quotes> {
        quotes(quoteSearch: quoteSearch, locale: nil)
    }
}
