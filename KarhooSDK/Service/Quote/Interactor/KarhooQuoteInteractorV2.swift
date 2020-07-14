//
//  KarhooQuoteInteractorV2.swift
//  KarhooSDK
//
//  Created by Jeevan Thandi on 14/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooQuoteInteractorV2: QuoteInteractor {

    private let quoteListIdRequest: RequestSender
    private let quotesRequest: RequestSender
    private var quoteSearch: QuoteSearch?
    private var quoteListId: QuoteListId?
    private let filterRidesWithETA: Int = 20
    private let refreshQuoteListMinimumValidity: Int = 10

    init(quoteListIdRequest: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         quotesRequest: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.quoteListIdRequest = quoteListIdRequest
        self.quotesRequest = quotesRequest
    }

    func set(quoteSearch: QuoteSearch) {

    }

    func execute<T>(callback: @escaping (Result<T>) -> Void) where T : KarhooCodableModel {

    }

    func cancel() {

    }
}
