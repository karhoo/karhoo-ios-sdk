//
//  MockUIConfigInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class MockUIConfigInteractor: UIConfigInteractor, MockInteractor {

    var cancelCalled: Bool = false
    func cancel() {
        cancelCalled = true
    }
    
    var callbackSet: CallbackClosure<UIConfig>?

    private(set) var uiConfigRequestSet: UIConfigRequest?
    func set(uiConfigRequest: UIConfigRequest) {
        self.uiConfigRequestSet = uiConfigRequest
    }
}
