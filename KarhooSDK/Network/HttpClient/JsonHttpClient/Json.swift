import Foundation

public typealias Json = [String: Any]

public func == (lhs: Json, rhs: Json ) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

public enum JsonError: KarhooError {
    case invalidJsonArguments
}
