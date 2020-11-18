//
//  VerifyQuoteInteractor.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 17/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol VerifyQuoteInteractor: KarhooExecutable {
    func set(verifyQuotePayload: VerifyQuotePayload)
}
