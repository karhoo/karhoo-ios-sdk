//
//  KarhooAdyenPublicKeyInteractorSpec.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 15/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class KarhooAdyenPublicKeyInteractorSpec: XCTestCase {
    private var testObject: KarhooAdyenPublicKeyInteractor!
    private var mockRequestSender: MockRequestSender!

    override func setUp() {
        super.setUp()

        mockRequestSender = MockRequestSender()
        testObject = KarhooAdyenPublicKeyInteractor(requestSender: mockRequestSender)
    }
    
    /**
     * When: Getting public key
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { ( _: Result<AdyenPublicKey>) in})
        mockRequestSender.assertRequestSendAndDecoded(endpoint: .adyenPublicKey,
                                                      method: .get,
                                                      payload: nil)
    }

    /**
     * When: Cancelling request
     * Then: request should cancel
     */
    func testCancelRequest() {
        testObject.cancel()
        XCTAssertTrue(mockRequestSender.cancelNetworkRequestCalled)
    }
    
    /**
       * Given: Getting Adyen public key
       * When: Get request succeeds
       * Then: Callback should be success
       */
      func testAdyenPublicKeySuccess() {
          let expectedResponse = AdyenPublicKey(key: "mock")
          var result: Result<AdyenPublicKey>?

          testObject.execute(callback: { response in
              result = response
          })

          mockRequestSender.triggerSuccessWithDecoded(value: expectedResponse)

          XCTAssertEqual("mock", result!.successValue()?.key)
      }

      /**
       * Given: Getting public key
       * When: Get request fails
       * Then: Callback should contain expected error
       */
      func testPaymentFail() {
          let expectedError = TestUtil.getRandomError()
        
        
          var result: Result<AdyenPublicKey>?

          testObject.execute(callback: { result = $0})

          mockRequestSender.triggerFail(error: expectedError)

          XCTAssertNil(result?.successValue())
          XCTAssertFalse(result!.isSuccess())
          XCTAssert(expectedError.equals(result!.errorValue()!))
      }
}
