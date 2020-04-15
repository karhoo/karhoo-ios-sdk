//
//  Observer.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public final class Observer<ResponseType: KarhooCodableModel> {
    let uuid: String
    public let closure: CallbackClosure<ResponseType>

    public init(_ closure: @escaping CallbackClosure<ResponseType>) {
        self.uuid = UUID().uuidString
        self.closure = closure
    }
}
