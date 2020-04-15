//
//  UserDetailsUpdateInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockUpdateuserDetailsInteractor: UpdaterUserDetailsInteractor, MockInteractor {
    
    var callbackSet: CallbackClosure<UserInfo>?
    var cancelCalled = false
    
    var userUpdateSet: UserDetailsUpdateRequest?
    func set(update: UserDetailsUpdateRequest) {
        userUpdateSet = update
    }
}
