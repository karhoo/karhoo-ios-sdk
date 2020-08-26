//
//  KarhooAdyenPaymentsInteractorSpec.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 25/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class KarhooAdyenPaymentsInteractorSpec: XCTestCase {
    
    private var testObject: KarhooAdyenPaymentsInteractor!
    private var mockRequestSender: MockRequestSender!
    
    override func setUp() {
        super.setUp()
    
        mockRequestSender = MockRequestSender()
        testObject =
        KarhooAdyenPaymentsInteractor(requestSender: mockRequestSender)
}


/**
  * When: Getting Adyen payments
  * Then: Expected method, path and payload should be set
  */
 func testRequestFormat() {
     testObject.execute(callback: { ( _: Result<AdyenPayment>) in})
     mockRequestSender.assertRequestSendAndDecoded(endpoint: .adyenPayments,
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
    

}
