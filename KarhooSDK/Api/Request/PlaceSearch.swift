//
//  PlaceSearch.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct PlaceSearch: KarhooCodableModel, Equatable {

    public let position: Position
    public let query: String
    public let sessionToken: String

    public init(position: Position = Position(),
                query: String = "",
                sessionToken: String) {
        self.position = position
        self.query = query
        self.sessionToken = sessionToken
    }
    
    enum CodingKeys: String, CodingKey {
        case sessionToken = "session_token"
        case position
        case query
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.position = (try? container.decode(Position.self, forKey: .position)) ?? Position()
        self.query = (try? container.decode(String.self, forKey: .query)) ?? ""
        self.sessionToken = (try? container.decode(String.self, forKey: .sessionToken)) ?? ""
    }
}
