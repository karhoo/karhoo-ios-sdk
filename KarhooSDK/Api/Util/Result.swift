//
//  Result.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(result: T, correlationId: String? = nil)
    case failure(error: KarhooError?, correlationId: String? = nil)

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

    public func isSuccess() -> Bool {
        switch self {
        case .success:
            return true

        default:
            return false
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

    public func successValue<E>(orErrorCallback: CallbackClosure<E>) -> T? {
        switch self {
        case .success(let result, _):
            return result
        case .failure(let error, _):
            orErrorCallback(.failure(error: error))
            return nil
        }
    }
}

public typealias CallbackClosure<T> = (Result<T>) -> Void
