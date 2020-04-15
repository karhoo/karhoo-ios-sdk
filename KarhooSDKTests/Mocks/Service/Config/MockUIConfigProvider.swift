//
//  MockUIConfigProvider.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class MockUIConfigProvider: UIConfigProvider {

    private var configCallbackSet: CallbackClosure<UIConfig>?

    private(set) var fetchConfigCalled = false
    private(set) var organisationSet: Organisation?
    private(set) var uiconfigRequestSet: UIConfigRequest?

    func fetchConfig(uiConfigRequest: UIConfigRequest,
                     organisation: Organisation,
                     callback: @escaping CallbackClosure<UIConfig>) {
        fetchConfigCalled = true
        self.uiconfigRequestSet = uiConfigRequest
        self.organisationSet = organisation
        self.configCallbackSet = callback
    }

    func triggerConfigCallbackResult(_ result: Result<UIConfig>) {
        configCallbackSet?(result)
    }

}
