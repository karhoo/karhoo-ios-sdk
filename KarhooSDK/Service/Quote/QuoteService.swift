//
//  QuoteService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol QuoteService {    
    func quotesV2(quoteSearch: QuoteSearch) -> PollCall<Quotes>
}
