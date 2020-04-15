//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockPasswordResetInteractor: PasswordResetInteractor, MockInteractor {

    var callbackSet: CallbackClosure<KarhooVoid>?
    var cancelCalled = false

    var emailSet: String?
    func set(email: String) {
        emailSet = email
    }
}
