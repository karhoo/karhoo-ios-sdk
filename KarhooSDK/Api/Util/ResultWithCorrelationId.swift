//
// Created by Bartlomiej Sopala on 10/07/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//


import Foundation

public enum ResultWithCorrelationId<T> {
    case success(result: T, correlationId: String?)
    case failure(error: KarhooError?, correlationId: String?)

    public func errorValue() -> KarhooError? {
        switch self {
        case .failure(let error, _):
            return error
        default:
            return nil
        }
    }

    public func successValue() -> T? {
        switch self {
        case .success(let result, _):
            return result
        default:
            return nil
        }
    }

    public func correlationId() -> String? {
        switch self {
        case .success(_, let correlationId):
            return correlationId
        case .failure(_, let correlationId):
            return correlationId
        }
    }

    public func isSuccess() -> Bool {
        switch self {
        case .success:
            return true

        default:
            return false
        }
    }

    public func successValue<E>(orErrorCallback: CallbackClosureWithCorrelationId<E>) -> T? {
        switch self {
        case .success(let result, _):
            return result
        case .failure(let error, let correlationId):
            orErrorCallback(.failure(error: error, correlationId: correlationId))
            return nil
        }
    }
}

public typealias CallbackClosureWithCorrelationId<T> = (ResultWithCorrelationId<T>) -> Void
