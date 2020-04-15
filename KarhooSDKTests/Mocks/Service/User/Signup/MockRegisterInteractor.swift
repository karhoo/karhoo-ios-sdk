//
//  MockSignupInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockRegisterInteractor: RegisterInteractor, MockInteractor {

    var callbackSet: CallbackClosure<UserInfo>?
    var cancelCalled = false

    var userRegistrationSet: UserRegistration?
    func set(userRegistration: UserRegistration) {
        userRegistrationSet = userRegistration
    }
}
