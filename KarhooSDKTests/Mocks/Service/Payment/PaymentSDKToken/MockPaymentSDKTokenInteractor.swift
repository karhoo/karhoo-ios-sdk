//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockPaymentSDKTokenInteractor: MockInteractor, PaymentSDKTokenInteractor {

    var callbackSet: CallbackClosure<PaymentSDKToken>?
    var cancelCalled = false

    private(set) var payloadSet: PaymentSDKTokenPayload?
    func set(payload: PaymentSDKTokenPayload) {
        self.payloadSet = payload
    }
}
