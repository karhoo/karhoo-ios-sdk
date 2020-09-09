//
//  MockAdyenPaymentMethodsInteractor.swift
//  KarhooSDKTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

@testable import KarhooSDK

final class MockAdyenPaymentMethodsInteractor: MockInteractor, AdyenPaymentMethodsInteractor {
    var cancelCalled: Bool = false
    var callbackSet: CallbackClosure<DecodableData>?
    
    private(set) var adyenPaymentMethodsRequest: AdyenPaymentMethodsRequest?
    func set(request: AdyenPaymentMethodsRequest) {
        self.adyenPaymentMethodsRequest = request
    }
}
