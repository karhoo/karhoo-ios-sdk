//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooPasswordResetInteractorSpec: XCTestCase {

    private var mockPasswordResetRequest: MockRequestSender!
    private var testObject: KarhooPasswordResetInteractor!

    override func setUp() {
        super.setUp()

        mockPasswordResetRequest = MockRequestSender()
        testObject = KarhooPasswordResetInteractor(requestSender: mockPasswordResetRequest)
    }

    /**
      * When: Making a password reset request
      * Then: Expected method, path and payload should be set
      */
    func testRequestFormat() {
        let testPayload = PasswordResetRequestPayloadMock().set(email: "some_email").build()

        testObject.set(email: "some_email")
        testObject.execute(callback: { (_:  Result<KarhooVoid>) in })

        mockPasswordResetRequest.assertRequestSend(endpoint: .passwordReset,
                                                   payload: testPayload)
    }

    /**
      * Given: Resetting password
      * When: Resetting password request succeeds
      * Then: Callback should be success
      */
    func testPasswordResetRequestSucceeds() {
        var result: Result<KarhooVoid>?
        testObject.set(email: "some_email")
        testObject.execute(callback: { result = $0 })

        mockPasswordResetRequest.triggerSuccess(response: KarhooVoid().encode()!)

        XCTAssert(result!.isSuccess())
    }

    /**
      * Given: Resetting password
      * When: Resetting password request fails
      * Then: Callback should be a fail
      */
    func testPasswordResetRequestFails() {
        let expectedError = TestUtil.getRandomError()

        var result: Result<KarhooVoid>?
        testObject.set(email: "some_email")
        testObject.execute(callback: { result = $0 })

        mockPasswordResetRequest.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result!.errorValue()))
        XCTAssertFalse(result!.isSuccess())
    }
}
