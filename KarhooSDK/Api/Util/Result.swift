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

    @available(*, deprecated, message: "errorValue() is deprecated and will be removed in next SDK version. getErrorValue() should be used instead")
    public func errorValue() -> KarhooError? {
        getErrorValue()
    }

    public func getErrorValue() -> KarhooError? {
        switch self {
        case .failure(let error, _):
            return error

        default:
            return nil
        }
    }

    @available(*, deprecated, message: "successValue() is deprecated and will be removed in next SDK version. getSuccessValue() should be used instead")
    public func successValue() -> T? {
        getSuccessValue()
    }

    public func getSuccessValue() -> T? {
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
    
    public func getCorrelationId() -> String? {
        switch self {
        case .success(_, let correlationId):
            return correlationId
        case .failure(_, let correlationId):
            return correlationId
        }
    }

    @available(*, deprecated, message: "successValue(orErrorCallback:) is deprecated and will be removed in next SDK version. getSuccessValue(orErrorCallback:) should be used instead")
    public func successValue<E>(orErrorCallback: CallbackClosure<E>) -> T? {
        getSuccessValue(orErrorCallback: orErrorCallback)
    }

    public func getSuccessValue<E>(orErrorCallback: CallbackClosure<E>) -> T? {
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
