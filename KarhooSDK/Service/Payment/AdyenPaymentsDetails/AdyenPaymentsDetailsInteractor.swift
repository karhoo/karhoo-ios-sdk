//
//  AdyenPaymentsDetailsInteractor.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 01/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol AdyenPaymentsDetailsInteractor:KarhooExecutable {
    func set(paymentsDetails: PaymentsDetailsRequestPayload)
}
