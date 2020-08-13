//
//  AdyenPaymentMethodsRequest.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentMethodsRequestPayload: Codable, KarhooCodableModel {
    public let channel: String?
    
    public init(channel: String? = "iOS") {
        self.channel = channel
    }
    
    enum CodingKeys: String, CodingKey {
        case channel
    }
}
