//
//  MockAdyenPaymentMethodsInteractor.swift
//  KarhooSDKTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

@testable import KarhooSDK

final class MockAdyenPaymentMethodsInteractor: MockInteractor, AdyenPaymentMethodsInteractor {
    var cancelCalled: Bool = false
    var callbackSet: CallbackClosure<AdyenPaymentMethods>?
    
    private(set) var adyenPaymentMethodsRequestPayload: AdyenPaymentMethodsRequestPayload?
    func set(adyenPaymentMethodsRequestPayload: AdyenPaymentMethodsRequestPayload) {
        self.adyenPaymentMethodsRequestPayload = adyenPaymentMethodsRequestPayload
    }
}
