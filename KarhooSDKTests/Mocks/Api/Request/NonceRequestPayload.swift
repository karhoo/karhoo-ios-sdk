//
//  GetNoncePayloadMock.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class NonceRequestPayloadMock {

    private var nonceRequestPayload: NonceRequestPayload

    init() {
        self.nonceRequestPayload = NonceRequestPayload(payer: Payer(), organisationId: "")
    }

    func set(payer: Payer) -> NonceRequestPayloadMock {
        self.nonceRequestPayload = NonceRequestPayload(payer: payer, organisationId: nonceRequestPayload.organisationId)
        return self
    }

    func set(organisationId: String) -> NonceRequestPayloadMock {
        self.nonceRequestPayload = NonceRequestPayload(payer: nonceRequestPayload.payer, organisationId: organisationId)
        return self
    }

    func build() -> NonceRequestPayload {
        return self.nonceRequestPayload
    }
}
