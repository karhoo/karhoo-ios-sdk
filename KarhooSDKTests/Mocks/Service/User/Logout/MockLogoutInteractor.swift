//
//  MockLogoutInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockLogoutInteractor: KarhooExecutable, MockInteractor {

    var callbackSet: CallbackClosure<KarhooVoid>?
    var cancelCalled = false
}
