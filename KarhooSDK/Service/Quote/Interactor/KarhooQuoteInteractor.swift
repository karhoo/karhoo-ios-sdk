//
//  KarhooQuoteInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooQuoteInteractor: QuoteInteractor {

    private let availabilityRequest: RequestSender
    private let quoteListIdRequest: RequestSender
    private let quotesRequest: RequestSender
    private var quoteSearch: QuoteSearch?
    private var quoteListId: QuoteListId?
    private var availableQuoteCategories: Categories?
    private let filterRidesWithETA: Int = 20
    private let refreshQuoteListMinimumValidity: Int = 10

    init(availabilityRequest: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         quoteListIdRequest: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         quotesRequest: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.availabilityRequest = availabilityRequest
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
        } else {
            requestAndHandleAvailability(callback: quotesCallback)
        }
    }

    func cancel() {
        availabilityRequest.cancelNetworkRequest()
        quoteListIdRequest.cancelNetworkRequest()
        quoteListId = nil
    }

    private func requestAndHandleAvailability(callback: @escaping CallbackClosure<Quotes>) {
        guard let payload = self.availabilitySearch else {
            return
        }

        availabilityRequest.requestAndDecode(payload: payload,
                                             endpoint: .availability,
                                             callback: { [weak self] (result: Result<Categories>) in
                                                self?.availableQuoteCategories = result.successValue()
                                                self?.requestAndHandleQuoteListId(callback: callback)
        })
    }

    private func requestAndHandleQuoteListId(callback: @escaping CallbackClosure<Quotes>) {
        guard let requestPayload = self.availabilitySearch else {
            return
        }

        let quoteListIdRequestPayload = QuoteListIdRequestPayload(origin: requestPayload.originPlaceId,
                                                                  destination: requestPayload.destinationPlaceId,
                                                                  dateScheduled: requestPayload.dateScheduled)

        quoteListIdRequest.requestAndDecode(payload: quoteListIdRequestPayload,
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
        let quoteCategories = CategoryQuoteMapper().map(categories: availableQuoteCategories?.categories ?? [],
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

private extension KarhooQuoteInteractor {

    private var availabilitySearch: AvailabilitySearch? {

        guard let quoteSearch = self.quoteSearch else {
            return nil
        }

        var dateScheduled: String?

        if let quoteSearchDate = quoteSearch.dateScheduled {
            let dateFormatter = KarhooNetworkDateFormatter(timeZone: quoteSearch.origin.timezone(),
                                                           formatType: .availability)

            dateScheduled = dateFormatter.toString(from: quoteSearchDate)
        }

        return AvailabilitySearch(origin: quoteSearch.origin.placeId,
                                  destination: quoteSearch.destination.placeId,
                                  dateScheduled: dateScheduled)
    }
}
