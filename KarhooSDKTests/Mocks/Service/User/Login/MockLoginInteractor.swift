//
//  MockLoginInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockLoginInteractor: LoginInteractor, MockInteractor {

    var callbackSet: CallbackClosure<UserInfo>?
    var cancelCalled = false

    var userLoginSet: UserLogin?
    func set(userLogin: UserLogin) {
        userLoginSet = userLogin
    }
}
