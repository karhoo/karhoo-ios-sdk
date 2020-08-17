//
//  AdyenPaymentMethodsMock.swift
//  KarhooSDKTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class AdyenPaymentMethodMock {
    
    private var adyenPaymentMethod: AdyenPaymentMethod
    
    init() {
        self.adyenPaymentMethod = AdyenPaymentMethod(brands: ["amex", "maestro", "visa"],
                                                     details: [],
                                                     name: "Credit Card",
                                                     supportsRecurring: true,
                                                     type: "scheme")
    }
    
    func build() -> AdyenPaymentMethod {
        return adyenPaymentMethod
    }
}
