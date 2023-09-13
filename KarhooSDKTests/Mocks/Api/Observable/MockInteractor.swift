//
//  MockInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooSDK

protocol MockInteractor: AnyObject, KarhooExecutable {
    associatedtype ResponseType
    var callbackSet: CallbackClosure<ResponseType>? { get set }
    func triggerSuccess(result: ResponseType)
    func triggerFail(error: KarhooError)
    var cancelCalled: Bool { get set }
}

extension MockInteractor {
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        callbackSet = { (response: Result<ResponseType>) -> Void in
            guard let response = response as? Result<T> else { return }
            callback(response)
        }
    }

    func triggerSuccess(result: ResponseType) {
        callbackSet?(.success(result: result))
    }

    func triggerFail(error: KarhooError) {
        callbackSet?(.failure(error: error))
    }

    func cancel() {
        cancelCalled = true
    }
}
