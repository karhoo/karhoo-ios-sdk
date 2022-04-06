//
//  AdyenPaymentMethodsProvider.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol AdyenPaymentMethodsInteractor: KarhooExecutable {
    func set(request: AdyenPaymentMethodsRequest)
    func set(paymentProviderAPIVersion: String)
}
