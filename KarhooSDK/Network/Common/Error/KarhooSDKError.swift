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
    var slug: String

    init(code: String,
         message: String,
         userMessage: String? = nil,
         slug: String? = nil) {
        self.code = code
        self.message = message
        self.userMessage = userMessage ?? message
        self.slug = slug ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case code
        case message
        case userMessage
        case slug
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        code = (try? container.decodeIfPresent(String.self, forKey: .code)) ?? ""
        let message = (try? container.decodeIfPresent(String.self, forKey: .message)) ?? ""
        let userMessage = (try? container.decodeIfPresent(String.self, forKey: .userMessage))

        self.message = message
        self.userMessage = userMessage ?? message
        self.slug = (try? container.decodeIfPresent(String.self, forKey: .slug)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(code, forKey: .code)
        try container.encode(message, forKey: .message)
        try container.encode(userMessage, forKey: .userMessage)
        try container.encode(slug, forKey: .slug)
    }
}
