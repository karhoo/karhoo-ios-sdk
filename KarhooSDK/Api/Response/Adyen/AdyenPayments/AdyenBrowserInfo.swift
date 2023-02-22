//
//  AdyenBrowserInfo.swift
//  KarhooSDK
//
//  Created by Mostafa Hadian on 04/03/2021.
//

import Foundation

public struct AdyenBrowserInfo: KarhooCodableModel {
    
    public let userAgent: String
    public let acceptHeader: String
    
    public init(userAgent: String = "",
                acceptHeader: String = "") {
        self.userAgent = userAgent
        self.acceptHeader = acceptHeader
    }
    
    enum CodingKeys: String, CodingKey {
        case userAgent
        case acceptHeader
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userAgent = (try? container.decodeIfPresent(String.self, forKey: .userAgent)) ?? ""
        self.acceptHeader = (try? container.decodeIfPresent(String.self, forKey: .acceptHeader)) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userAgent, forKey: .userAgent)
        try container.encode(acceptHeader, forKey: .acceptHeader)
    }
}
