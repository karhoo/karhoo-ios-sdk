//
//  AnyCodable.swift
//  KarhooSDK
//
//  Created by Jeevan Thandi on 05/10/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

/* https://github.com/levantAJ/AnyCodable/tree/master/AnyCodable
 * Extension so that KarhooCodableModel type can encode / decode [String: Any] types as Any does not conform to codable by default
 * other options: https://github.com/Flight-School/AnyCodable
 */

extension KeyedEncodingContainer {
    /// Encodes the given value for the given key.
    ///
    /// - parameter value: The value to encode.
    /// - parameter key: The key to associate the value with.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    public mutating func encode(_ value: [String: Any], forKey key: KeyedEncodingContainer<K>.Key) throws {
        var container = nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
        try container.encode(value)
    }

    /// Encodes the given value for the given key.
    ///
    /// - parameter value: The value to encode.
    /// - parameter key: The key to associate the value with.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    public mutating func encode(_ value: [Any], forKey key: KeyedEncodingContainer<K>.Key) throws {
        var container = nestedUnkeyedContainer(forKey: key)
        try container.encode(value)
    }

    /// Encodes the given value for the given key if it is not `nil`.
    ///
    /// - parameter value: The value to encode.
    /// - parameter key: The key to associate the value with.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    public mutating func encodeIfPresent(_ value: [String: Any]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            var container = nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
            try container.encode(value)
        } else {
            try encodeNil(forKey: key)
        }
    }

    /// Encodes the given value for the given key if it is not `nil`.
    ///
    /// - parameter value: The value to encode.
    /// - parameter key: The key to associate the value with.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    public mutating func encodeIfPresent(_ value: [Any]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            var container = nestedUnkeyedContainer(forKey: key)
            try container.encode(value)
        } else {
            try encodeNil(forKey: key)
        }
    }
}

private extension KeyedEncodingContainer where K == AnyCodingKey {
    mutating func encode(_ value: [String: Any]) throws {
        for (k, v) in value {
            let key = AnyCodingKey(stringValue: k)!
            switch v {
            case is NSNull:
                try encodeNil(forKey: key)
            case let string as String:
                try encode(string, forKey: key)
            case let int as Int:
                try encode(int, forKey: key)
            case let bool as Bool:
                try encode(bool, forKey: key)
            case let double as Double:
                try encode(double, forKey: key)
            case let dict as [String: Any]:
                try encode(dict, forKey: key)
            case let array as [Any]:
                try encode(array, forKey: key)
            default:
                debugPrint("⚠️ Unsuported type!", v)
                continue
            }
        }
    }
}

private extension UnkeyedEncodingContainer {
    /// Encodes the given value.
    ///
    /// - parameter value: The value to encode.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    mutating func encode(_ value: [Any]) throws {
        for v in value {
            switch v {
            case is NSNull:
                try encodeNil()
            case let string as String:
                try encode(string)
            case let int as Int:
                try encode(int)
            case let bool as Bool:
                try encode(bool)
            case let double as Double:
                try encode(double)
            case let dict as [String: Any]:
                try encode(dict)
            case let array as [Any]:
                var values = nestedUnkeyedContainer()
                try values.encode(array)
            default:
                debugPrint("⚠️ Unsuported type!", v)
            }
        }
    }

    /// Encodes the given value.
    ///
    /// - parameter value: The value to encode.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    mutating func encode(_ value: [String: Any]) throws {
        var container = self.nestedContainer(keyedBy: AnyCodingKey.self)
        try container.encode(value)
    }
}

struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = String(intValue)
    }
}

extension KeyedDecodingContainer {
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key
    ///   and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    public func decode(_ type: [Any].Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> [Any] {
        var values = try nestedUnkeyedContainer(forKey: key)
        return try values.decode(type)
    }

    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key
    ///   and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    public func decode(_ type: [String: Any].Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> [String: Any] {
        let values = try nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
        return try values.decode(type)
    }

    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    public func decodeIfPresent(_ type: [Any].Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> [Any]? {
        guard contains(key),
              try decodeNil(forKey: key) == false else { return nil }
        return try decode(type, forKey: key)
    }

    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    public func decodeIfPresent(_ type: [String: Any].Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> [String: Any]? {
        guard contains(key),
              try decodeNil(forKey: key) == false else { return nil }
        return try decode(type, forKey: key)
    }
}

private extension KeyedDecodingContainer {
    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary: [String: Any] = [:]
        for key in allKeys {
            if try decodeNil(forKey: key) {
                dictionary[key.stringValue] = NSNull()
            } else if let bool = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = bool
            } else if let string = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = string
            } else if let int = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = int
            } else if let double = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = double
            } else if let dict = try? decode([String: Any].self, forKey: key) {
                dictionary[key.stringValue] = dict
            } else if let array = try? decode([Any].self, forKey: key) {
                dictionary[key.stringValue] = array
            }
        }
        return dictionary
    }
}

private extension UnkeyedDecodingContainer {
    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var elements: [Any] = []
        while !isAtEnd {
            if try decodeNil() {
                elements.append(NSNull())
            } else if let int = try? decode(Int.self) {
                elements.append(int)
            } else if let bool = try? decode(Bool.self) {
                elements.append(bool)
            } else if let double = try? decode(Double.self) {
                elements.append(double)
            } else if let string = try? decode(String.self) {
                elements.append(string)
            } else if let values = try? nestedContainer(keyedBy: AnyCodingKey.self),
                      let element = try? values.decode([String: Any].self) {
                elements.append(element)
            } else if var values = try? nestedUnkeyedContainer(),
                      let element = try? values.decode([Any].self) {
                elements.append(element)
            }
        }
        return elements
    }
}
