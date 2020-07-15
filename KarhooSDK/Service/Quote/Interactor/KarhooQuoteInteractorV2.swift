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
        cancel()
        self.quoteSearch = quoteSearch
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let quotesCallback = callback as? CallbackClosure<Quotes> else {
            return
        }

        if let quoteListId = self.quoteListId {
            makeQuotesRequest(quoteListId: quoteListId, callback: quotesCallback)
        }
    }

    func cancel() {
        quoteListIdRequest.cancelNetworkRequest()
        quoteListId = nil
    }

    private func requestAndHandleQuoteListId(callback: @escaping CallbackClosure<Quotes>) {
        guard let requestPayload = self.quoteRequestPayload else {
            return
        }

        quoteListIdRequest.requestAndDecode(payload: requestPayload,
                                            endpoint: .quoteListId,
                                            callback: { [weak self] (result: Result<QuoteListId>) in
                                                if let quoteListId = result.successValue() {
                                                    self?.makeQuotesRequest(quoteListId: quoteListId,
                                                                            callback: callback)
                                                } else {
                                                    callback(.failure(error: result.errorValue()))
                                                }

        })
    }

    private func makeQuotesRequest(quoteListId: QuoteListId, callback: @escaping CallbackClosure<Quotes>) {
        self.quoteListId = quoteListId

        quotesRequest.requestAndDecode(payload: nil,
                                       endpoint: .quotes(identifier: quoteListId.identifier),
                                       callback: { [weak self] (result: Result<QuoteList>) in
                                        if let successValue = result.successValue() {
                                            self?.handleSuccessfulQuoteRequest(quoteList: successValue,
                                                                               callback: callback)
                                        } else {
                                            self?.handleFailedQuoteRequest(error: result.errorValue(),
                                                                           callback: callback)
                                        }
        })
    }

    private func handleFailedQuoteRequest(error: KarhooError?,
                                          callback: @escaping CallbackClosure<Quotes>) {
        if error?.type != .couldNotGetEstimates {
            callback(.failure(error: error))
            return
        }

        cancelSearchAndRequestQuoteId(callback: callback)
    }

    private func handleSuccessfulQuoteRequest(quoteList: QuoteList, callback: @escaping CallbackClosure<Quotes>) {
        guard quoteList.validity > refreshQuoteListMinimumValidity else {
            cancelSearchAndRequestQuoteId(callback: callback)
            return
        }

        let filteredQuotes = quoteList.quoteItems.filter { $0.qtaHighMinutes <= filterRidesWithETA }
        let quoteCategories = CategoryQuoteMapper().map(categories: quoteList.availability.vehicles.classes,
                                                        toQuotes: filteredQuotes)
        let quotes = Quotes(quoteListId: quoteList.listId,
                            quoteCategories: quoteCategories,
                            all: filteredQuotes)

        callback(.success(result: quotes))
    }

    private func cancelSearchAndRequestQuoteId(callback: @escaping CallbackClosure<Quotes>) {
        cancel()
        requestAndHandleQuoteListId(callback: callback)
    }
}

private extension KarhooQuoteInteractorV2 {

    private var quoteRequestPayload: QuoteRequestPayload? {

        guard let quoteSearch = self.quoteSearch else {
            return nil
        }

        var dateScheduled: String?

        if let quoteSearchDate = quoteSearch.dateScheduled {
            let dateFormatter = KarhooNetworkDateFormatter(timeZone: quoteSearch.origin.timezone(),
                                                           formatType: .availability)

            dateScheduled = dateFormatter.toString(from: quoteSearchDate)
        }

        let origin = QuoteRequestPoint(latitude: quoteSearch.origin.position.latitude,
                                       longitude: quoteSearch.origin.position.longitude,
                                       displayAddress: quoteSearch.origin.address.displayAddress)

        let destination = QuoteRequestPoint(latitude: quoteSearch.destination.position.latitude,
                                            longitude: quoteSearch.destination.position.longitude, displayAddress: quoteSearch.destination.address.displayAddress)

        return QuoteRequestPayload(origin: origin,
                                  destination: destination,
                                  dateScheduled: dateScheduled)
    }
}
