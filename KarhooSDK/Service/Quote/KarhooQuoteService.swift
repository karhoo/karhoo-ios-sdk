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
    private let vehicleRulesInteractor: VehicleRulesInteractor

    init(
        quoteInteractor: QuoteInteractor = KarhooQuoteInteractor(),
        coverageInteractor: QuoteCoverageInteractor = KarhooQuoteCoverageInteractor(),
        verifyQuoteInteractor: VerifyQuoteInteractor = KarhooVerifyQuoteInteractor(),
        vehicleRulesInteractor: VehicleRulesInteractor = KarhooVehicleRulesInteractor()
    ) {
        self.quoteInteractor = quoteInteractor
        self.coverageInteractor = coverageInteractor
        self.verifyQuoteInteractor = verifyQuoteInteractor
        self.vehicleRulesInteractor = vehicleRulesInteractor
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

    func getVehiclesRules() -> Call<VehicleRules> {
        return Call(executable: vehicleRulesInteractor)
    }
}
