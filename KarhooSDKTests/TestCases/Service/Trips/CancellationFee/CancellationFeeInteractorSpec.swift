//
//  CancellationFeeInteractorSpec.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 03/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class CancellationFeeInteractorSpec: XCTestCase {

    private var mockCancellationFeeRequest: MockRequestSender!
    private var testObject: KarhooCancellationFeeInteractor!

    private let identifier = "bookingID"
    
    private let fee = CancellationFeePrice(currency: "GPB", type: "ABC", value: 10)

    override func setUp() {
        super.setUp()

        mockCancellationFeeRequest = MockRequestSender()
        testObject = KarhooCancellationFeeInteractor(requestSender: mockCancellationFeeRequest)
        testObject.set(identifier: identifier)
     
        
    }

    /**
     * When: Making a request to cancellation fee
     * Then: Expected method, path and payload should be set
     */

    func testRequestFormat() {
        testObject.execute(callback: { (_:Result<KarhooVoid>) in  })

        let endpoint = APIEndpoint.cancellationFee(identifier: identifier)

        mockCancellationFeeRequest.assertRequestSendAndDecoded(endpoint: endpoint,
                                                               method: .get,
                                                               payload: nil)
    }

    /**
      * Given: Requesting cancellation fee for a trip
      * When: The request succeeds with a true
      * Then: Callback should be a success with a cancellation fee result
      */
    func testRequestSuccessWithCancellationFee() {
        var capturedCallback: Result<CancellationFee>?
        testObject.execute(callback: { capturedCallback = $0 })
        
        let cancellationFee = CancellationFee(cancellationFee: true, fee: fee)
        mockCancellationFeeRequest.triggerSuccessWithDecoded(value: cancellationFee)
        
        XCTAssertEqual(capturedCallback!.successValue()!.cancellationFee, true)
    }
    
    /**
      * Given: Requesting cancellation fee for a trip
      * When: The request succeeds with a false
      * Then: Callback should be a success with a cancellation fee result
      */
    func testRequestSuccessWithoutCancellationFee() {
        var capturedCallback: Result<CancellationFee>?
        testObject.execute(callback: { capturedCallback = $0 })
        
        let cancellationFee = CancellationFee(cancellationFee: false)
        mockCancellationFeeRequest.triggerSuccessWithDecoded(value: cancellationFee)
        
        XCTAssertEqual(capturedCallback!.successValue()!.cancellationFee, false)
    }

    /**
      * Given: Requesting cancellation fee for a trip
      * When: The request fails
      * Then: Callback should be a fail with expected error
      */
    func testRequestFailure() {
        let expectedError = TestUtil.getRandomError()

        var capturedCallback: Result<CancellationFee>?
        testObject.execute(callback: { capturedCallback = $0 })

        mockCancellationFeeRequest.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(capturedCallback!.errorValue()))
    }

    /**
      * When: Cancelling the request for cancellation fee
      * Then: Cancellation fee request should cancel
      */
    func testCancelRequest() {
        testObject.cancel()
        XCTAssertTrue(mockCancellationFeeRequest.cancelNetworkRequestCalled)
    }
}

