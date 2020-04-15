//
//  MockAddPaymentDetailsInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooSDK

final class MockAddPaymentDetailsInteractor: MockInteractor, AddPaymentDetailsInteractor {

    var callbackSet: CallbackClosure<Nonce>?
    var cancelCalled = false

    private(set) var addPaymentDetailsPayloadSet: AddPaymentDetailsPayload?
    func set(addPaymentDetailsPayload: AddPaymentDetailsPayload) {
        self.addPaymentDetailsPayloadSet = addPaymentDetailsPayload
    }
}
