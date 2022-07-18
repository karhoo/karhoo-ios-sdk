//
//  QuoteService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol QuoteService {    
    func quotes(quoteSearch: QuoteSearch) -> PollCall<Quotes>
    func coverage(coverageRequest: QuoteCoverageRequest) -> Call<QuoteCoverage>
    func verifyQuote(verifyQuotePayload: VerifyQuotePayload) -> Call<Quote>
    func getVehiclesRules() -> Call<VehicleRules>
}
