//
//  KarhooExecutable.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol KarhooExecutable {
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>)
    func cancel()
}


public protocol KarhooExecutableWithCorrelationId {
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosureWithCorrelationId<T>)
    func cancel()
}