//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct MeetingPoint: Codable {

    public let position: Position
    public let instructions: String
    public let type: MeetingPointType

    public init(position: Position = Position(),
                instructions: String = "",
                type: MeetingPointType = .notSet) {
        self.position = position
        self.instructions = instructions
        self.type = type
    }

    enum CodingKeys: String, CodingKey {
        case position
        case instructions
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.position = (try? container.decode(Position.self, forKey: .position)) ?? Position()
        self.instructions = (try? container.decode(String.self, forKey: .instructions)) ?? ""
        self.type = (try? container.decode(MeetingPointType.self, forKey: .type)) ?? .notSet
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(position, forKey: .position)
        try container.encode(instructions, forKey: .instructions)
        try container.encode(type, forKey: .type)
    }
}
