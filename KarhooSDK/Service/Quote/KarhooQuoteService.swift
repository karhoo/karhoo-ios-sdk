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

public struct VehicleRules: Codable, KarhooCodableModel {
    let rules: [VehicleRule]

    enum CodingKeys: String, CodingKey {
        case rules = "mapping"
    }
}

public struct VehicleRule: Codable {
    let type: String
    let tags: [String]
    let imagePath: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case tags
        case imagePath = "image_png"
    }
}

protocol VehicleRulesInteractor: KarhooExecutable {
}

final class KarhooVehicleRulesInteractor: VehicleRulesInteractor {
    private var requestSender: RequestSender

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.requestSender = requestSender
    }

    func execute<T>(callback: @escaping CallbackClosure<T>) where T : KarhooCodableModel {
       
        requestSender.requestAndDecode(
            payload: nil,
            endpoint: .vehicleRules,
            callback: callback
        )
    }
    
    func cancel() {
        requestSender.cancelNetworkRequest()
    }

}
