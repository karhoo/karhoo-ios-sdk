//
//  Nonce.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Nonce: KarhooCodableModel, Equatable {

    public let nonce: String
    public let cardType: String
    public let lastFour: String

    public init(nonce: String = "",
                cardType: String = "",
                lastFour: String = "") {
        self.nonce = nonce
        self.cardType = cardType
        self.lastFour = lastFour
    }

    enum CodingKeys: String, CodingKey {
        case cardType = "card_type"
        case lastFour = "last_four"
        case nonce
    }
}
