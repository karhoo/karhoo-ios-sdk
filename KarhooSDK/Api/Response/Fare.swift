//
//  Fare.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Fare: KarhooCodableModel {

    public let state: String
    public let expectedFinalTime: String
    public let expectedIn: String
    public let breakdown: FareComponent

    public init(state: String = "",
                expectedFinalTime: String = "",
                expectedIn: String = "",
                breakdown: FareComponent = FareComponent()) {
        self.state = state
        self.expectedFinalTime = expectedFinalTime
        self.expectedIn = expectedIn
        self.breakdown = breakdown
    }

    enum CodingKeys: String, CodingKey {
        case state
        case expectedFinalTime = "expected_final_time"
        case expectedIn = "expected_in"
        case breakdown
    }

    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.state = (try? container.decodeIfPresent(String.self, forKey: .state)) ?? ""
        self.expectedFinalTime = (try? container.decodeIfPresent(String.self, forKey: .expectedFinalTime)) ?? ""
        self.expectedIn = (try? container.decodeIfPresent(String.self, forKey: .expectedIn)) ?? ""
        self.breakdown = (try? container.decodeIfPresent(FareComponent.self, forKey: .breakdown)) ?? FareComponent()
    }

    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(state, forKey: .state)
        try container.encode(expectedFinalTime, forKey: .expectedFinalTime)
        try container.encode(expectedIn, forKey: .expectedIn)
        try container.encode(breakdown, forKey: .breakdown)
    }
}
