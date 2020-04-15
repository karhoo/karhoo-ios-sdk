//
//  Call.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

open class Call<T: KarhooCodableModel> {

    private let executable: KarhooExecutable

    public init(executable: KarhooExecutable) {
        self.executable = executable
    }

    open func execute(callback: @escaping CallbackClosure<T>) {
        executable.execute(callback: callback)
    }
}
