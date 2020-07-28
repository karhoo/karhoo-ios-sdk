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
    
    func quotesV2(quoteSearch: QuoteSearch) -> PollCall<Quotes>
}
