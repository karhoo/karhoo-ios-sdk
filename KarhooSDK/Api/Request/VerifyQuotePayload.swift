//
//  VerifyQuotePayload.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 17/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct VerifyQuotePayload: KarhooCodableModel {

   public let quoteID: String
    
    public init(quoteID: String = "") {
        self.quoteID = quoteID
    }

    enum CodingKeys: String, CodingKey {
        case quoteID = "quote_id"
    }
}
