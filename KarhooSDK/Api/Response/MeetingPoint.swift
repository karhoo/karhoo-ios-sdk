//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct MeetingPoint: Codable {

    public let position: Position
    public let instructions: String
    public let type: MeetingPointType
    public let note: String

    public init(position: Position = Position(),
                instructions: String = "",
                type: MeetingPointType = .notSet,
                note: String = "") {
        self.position = position
        self.instructions = instructions
        self.type = type
        self.note = note
    }

    enum CodingKeys: String, CodingKey {
        case position
        case instructions
        case type
        case note
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.position = (try? container.decodeIfPresent(Position.self, forKey: .position)) ?? Position()
        self.instructions = (try? container.decodeIfPresent(String.self, forKey: .instructions)) ?? ""
        self.type = (try? container.decodeIfPresent(MeetingPointType.self, forKey: .type)) ?? .notSet
        self.note = (try? container.decodeIfPresent(String.self, forKey: .note)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(position, forKey: .position)
        try container.encode(instructions, forKey: .instructions)
        try container.encode(type, forKey: .type)
        try container.encode(note, forKey: .note)
    }
}
