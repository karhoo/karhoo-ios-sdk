//
//  AdyenSDKData.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 01/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenSDKData: KarhooCodableModel {
    // TODO: Find out the parameters of this object 
    public let MD: String
    public let PaReq: String
    public let TermUrl: String
    
    public init(MD: String = "",
                PaReq: String = "",
                TermUrl: String = "") {
        self.MD = MD
        self.PaReq = PaReq
        self.TermUrl = TermUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case MD
        case PaReq
        case TermUrl
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.MD = (try? container.decode(String.self, forKey: .MD)) ?? ""
        self.PaReq = (try? container.decode(String.self, forKey: .PaReq)) ?? ""
        self.TermUrl = (try? container.decode(String.self, forKey: .TermUrl)) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(MD, forKey: .MD)
        try container.encode(PaReq, forKey: .PaReq)
        try container.encode(TermUrl, forKey: .TermUrl)
    }
}
