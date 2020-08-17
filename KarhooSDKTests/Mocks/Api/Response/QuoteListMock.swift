//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class QuoteListMock {

    private var quoteList: QuoteList

    init() {
        self.quoteList = QuoteList()
    }

    func set(status: String) -> QuoteListMock {
        createDataForQuoteList(status: status)
        return self
    }

    func set(quoteListId: String) -> QuoteListMock {
        createDataForQuoteList(listId: quoteListId)
        return self
    }

    func set(validity: Int) -> QuoteListMock {
        createDataForQuoteList(validity: validity)
        return self
    }

    func add(quoteItem: Quote) -> QuoteListMock {
        createDataForQuoteList(quoteItem: quoteItem)
        return self
    }

    func build() -> QuoteList {
        return quoteList
    }

    private func createDataForQuoteList(quoteItem: Quote = Quote(),
                                        status: String? = nil,
                                        listId: String? = nil,
                                        validity: Int? = nil) {

        let status = status ?? quoteList.status
        let listId = listId ?? quoteList.listId
        let validity = validity ?? quoteList.validity
        let quoteListItems = getQuoteItemList(quoteItem: quoteItem)

        self.quoteList = QuoteList(
                quoteItems: quoteListItems,
                quotes: quoteListItems,
                listId: listId,
                status: status,
                validity: validity)
    }

    private func getQuoteItemList(quoteItem: Quote) -> [Quote] {
        if !quoteItem.equals(Quote()) {
            let updatedList = quoteList.quoteItems + [quoteItem]
            return updatedList
        }
        return quoteList.quoteItems
    }
}
