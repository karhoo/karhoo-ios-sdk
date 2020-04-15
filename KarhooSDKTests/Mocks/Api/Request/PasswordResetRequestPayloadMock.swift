//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class PasswordResetRequestPayloadMock {

    private var passwordResetRequestPayload: PasswordResetRequestPayload

    init() {
        self.passwordResetRequestPayload = PasswordResetRequestPayload(email: "")
    }

    func set(email: String) -> PasswordResetRequestPayloadMock {
        self.passwordResetRequestPayload = PasswordResetRequestPayload(email: email)

        return self
    }

    func build() -> PasswordResetRequestPayload {
        return passwordResetRequestPayload
    }
}
