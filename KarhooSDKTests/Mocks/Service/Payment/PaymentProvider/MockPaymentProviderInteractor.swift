//
//  MockPaymentProviderInteractor.swift
//  KarhooSDKTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

@testable import KarhooSDK

final class MockPaymentProviderInteractor: MockInteractor, PaymentProviderInteractor {

    var cancelCalled: Bool = false
    var callbackSet: CallbackClosure<PaymentProvider>?
}
