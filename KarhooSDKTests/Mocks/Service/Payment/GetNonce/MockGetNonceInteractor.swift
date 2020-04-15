//
//  MockGetNonceInteractor.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooSDK

final class MockGetNonceInteractor: MockInteractor, GetNonceInteractor {

    var cancelCalled: Bool = false
    var callbackSet: CallbackClosure<Nonce>?

    private(set) var nonceRequestPayloadSet: NonceRequestPayload?
    func set(nonceRequestPayload: NonceRequestPayload) {
        nonceRequestPayloadSet = nonceRequestPayload
    }
}
