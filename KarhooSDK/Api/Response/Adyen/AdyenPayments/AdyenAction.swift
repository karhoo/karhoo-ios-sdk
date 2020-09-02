//
//  AdyenAction.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 27/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenAction: KarhooCodableModel {
    
    public let paymentData: String
    public let paymentMethodType: String
    public let url: String
    public let data: AdyenData
    public let method: String
    public let type: String
    public let token: String
    public let sdkData: AdyenSDKData
    
    public init(paymentData: String = "",
                paymentMethodType: String = "",
                url: String = "",
                data: AdyenData = AdyenData(),
                method: String = "",
                type: String = "",
                token: String = "",
                sdkData: AdyenSDKData = AdyenSDKData()) {
        self.paymentData = paymentData
        self.paymentMethodType = paymentMethodType
        self.url = url
        self.data = data
        self.method = method
        self.type = type
        self.token = token
        self.sdkData = sdkData
    }
    
    enum CodingKeys: String, CodingKey {
        case paymentData
        case paymentMethodType
        case url
        case data
        case method
        case type
        case token
        case sdkData
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.paymentData = (try? container.decode(String.self, forKey: .paymentData)) ?? ""
        self.paymentMethodType = (try? container.decode(String.self, forKey: .paymentMethodType)) ?? ""
        self.url = (try? container.decode(String.self, forKey: .url)) ?? ""
        self.data = (try? container.decode(AdyenData.self, forKey: .data)) ?? AdyenData()
        self.method = (try? container.decode(String.self, forKey: .method)) ?? ""
        self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
        self.token = (try? container.decode(String.self, forKey: .token)) ?? ""
        self.sdkData = (try? container.decode(AdyenSDKData.self, forKey: .token)) ?? AdyenSDKData()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(paymentData, forKey: .paymentData)
        try container.encode(paymentMethodType, forKey: .paymentMethodType)
        try container.encode(url, forKey: .url)
        try container.encode(data, forKey: .data)
        try container.encode(method, forKey: .method)
        try container.encode(type, forKey: .type)
        try container.encode(token, forKey: .token)
        try container.encode(sdkData, forKey: .sdkData)
    }
}
