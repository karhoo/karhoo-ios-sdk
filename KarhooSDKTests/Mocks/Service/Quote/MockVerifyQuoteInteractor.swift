//
//  MockVerifyQuoteInteractor.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 17/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockVerifyQuoteInteractor: VerifyQuoteInteractor, MockInteractor {

    var callbackSet: CallbackClosure<Quote>?
    var cancelCalled = false

    var verifyQuotePayloadSet: VerifyQuotePayload?
    func set(verifyQuotePayload: VerifyQuotePayload) {
        verifyQuotePayloadSet = verifyQuotePayload
    }
}
