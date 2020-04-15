//
//  AddPaymentDetailsInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol AddPaymentDetailsInteractor: KarhooExecutable {
    func set(addPaymentDetailsPayload: AddPaymentDetailsPayload)
}
