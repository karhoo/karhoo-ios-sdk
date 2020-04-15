//
//  KarhooSDKError.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

struct KarhooSDKError: KarhooError, KarhooCodableModel {
    let code: String
    let message: String
    let userMessage: String
    var statusCode: Int = 0

    init(code: String,
         message: String,
         userMessage: String? = nil) {
        self.code = code
        self.message = message
        self.userMessage = userMessage ?? message
    }

    enum CodingKeys: String, CodingKey {
        case code
        case message
        case userMessage
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.code = (try? container.decode(String.self, forKey: .code)) ?? ""
        let message = (try? container.decode(String.self, forKey: .message)) ?? ""
        let userMessage = (try? container.decode(String.self, forKey: .userMessage))

        self.message = message
        self.userMessage = userMessage ?? message
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(code, forKey: .code)
        try container.encode(message, forKey: .message)
        try container.encode(userMessage, forKey: .userMessage)
    }
}
