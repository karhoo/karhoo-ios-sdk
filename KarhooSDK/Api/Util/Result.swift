//
//  Result.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(result: T)
    case failure(error: KarhooError?)

    public func errorValue() -> KarhooError? {
        switch self {
        case .failure(let error):
            return error

        default:
            return nil
        }
    }

    public func successValue() -> T? {
        switch self {
        case .success(let result):
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

    public func successValue<E>(orErrorCallback: CallbackClosure<E>) -> T? {
        switch self {
        case .success(let result):
            return result
        case .failure(let error):
            orErrorCallback(.failure(error: error))
            return nil
        }
    }
}

public typealias CallbackClosure<T> = (Result<T>) -> Void
