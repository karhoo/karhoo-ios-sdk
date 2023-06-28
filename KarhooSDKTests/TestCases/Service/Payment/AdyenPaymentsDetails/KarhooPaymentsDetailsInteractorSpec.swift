//
//  KarhooPaymentsDetailsInteractorSpec.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 01/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class KarhooAdyenPaymentsDetailsInteractorSpec: XCTestCase {
    
    private var testObject: KarhooAdyenPaymentsDetailsInteractor!
    private var mockRequestSender: MockRequestSender!
    
    override func setUp() {
        super.setUp()
        
        mockRequestSender = MockRequestSender()
        testObject =
            KarhooAdyenPaymentsDetailsInteractor(requestSender: mockRequestSender)
    }
    
    
    /**
     * When: Getting Adyen payments
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { ( _: Result<DecodableData>) in})
        mockRequestSender.assertRequestSend(endpoint: .adyenPaymentsDetails(paymentAPIVersion: ""),
                                            method: .post,
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
     * Given: Getting Adyen payments
     * When: Get Adyen payments request succeeds
     * Then: Callback should be success
     */
    func testAdyenPaymentDetailsSuccess() {
        var capturedResult: Result<DecodableData>?

        testObject.execute(callback: { capturedResult = $0})

        mockRequestSender.triggerSuccess(response: Data())

        XCTAssertNotNil(capturedResult?.getSuccessValue())
        XCTAssertEqual(capturedResult?.getSuccessValue()?.data, Data())
    }

    /**
     * Given: Getting Adyen payments
     * When: Get Adyen payments request fails
     * Then: Callback should contain expected error
     */
    func testAdyenPaymentDetailsFails() {
        let expectedError = TestUtil.getRandomError()

        var capturedResult: Result<DecodableData>?

        testObject.execute(callback: { capturedResult = $0})

        mockRequestSender.triggerFail(error: expectedError)

        XCTAssertNil(capturedResult?.getSuccessValue())
        XCTAssert(expectedError.equals(capturedResult!.getErrorValue()!))
    }
}
