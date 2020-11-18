//
//  KarhooVerifyQuoteInteractor.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 17/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooVerifyQuoteInteractor: VerifyQuoteInteractor {
    private var verifyQuoteRequestSender: RequestSender
    private var verifyQuotePayload: VerifyQuotePayload?
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.verifyQuoteRequestSender = requestSender
    }
    
    func set(verifyQuotePayload: VerifyQuotePayload) {
        self.verifyQuotePayload = verifyQuotePayload
    }
    
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let verifyQuotePayload = self.verifyQuotePayload else {
            return
        }
        
        verifyQuoteRequestSender.requestAndDecode(payload: verifyQuotePayload,
                                                  endpoint: verifyQuoteEndpoint(quoteID: verifyQuotePayload.quoteID),
                                                  callback: callback)
    }

    
    func cancel() {
        verifyQuoteRequestSender.cancelNetworkRequest()
    }
        
    private func verifyQuoteEndpoint(quoteID: String) -> APIEndpoint {
        return .verifyQuote(quoteID: quoteID)
    }
}
