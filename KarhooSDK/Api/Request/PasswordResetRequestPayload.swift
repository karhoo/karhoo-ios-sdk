//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct PasswordResetRequestPayload: KarhooCodableModel {

    let email: String

    init(email: String = "") {
        self.email = email
    }
}
