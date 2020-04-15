//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class PaymentSDKTokenMock {
    private var paymentSDKToken: PaymentSDKToken

    init() {
        self.paymentSDKToken = PaymentSDKToken(token: "")
    }

    func set(token: String) -> PaymentSDKTokenMock {
        paymentSDKToken = PaymentSDKToken(token: token)
        return self
    }

    func build() -> PaymentSDKToken {
        return paymentSDKToken
    }
}
