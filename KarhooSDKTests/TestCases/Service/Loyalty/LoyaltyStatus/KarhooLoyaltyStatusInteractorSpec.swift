//
//  KarhooLoyaltyStatusInteractorSpec.swift
//  KarhooSDKTests
//
//  Created by Edward Wilkins on 22/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooLoyaltyStatusInteractorSpec: XCTestCase {
    
    private var mockLoyaltyStatusRequest: MockRequestSender!
    private var testObject: KarhooLoyaltyStatusInteractor!
    
    private let identifier = "some_id"
    
    private let loyaltyStatusMock = LoyaltyStatus(balance: 10, canBurn: true, canEarn: true)
    
    override func setUp() {
        super.setUp()
        
        mockLoyaltyStatusRequest = MockRequestSender()
        
        testObject = KarhooLoyaltyStatusInteractor(requestSender: mockLoyaltyStatusRequest)
        testObject.set(identifier: identifier)
    }
    
    /**
     * When: Making a request to loyalty balance
     * Then: Expected method, path and payload should be set
     */

    func testRequestFormat() {
        testObject.execute(callback: { (_:Result<KarhooVoid>) in  })

        let endpoint = APIEndpoint.loyaltyStatus(identifier: identifier)

        mockLoyaltyStatusRequest.assertRequestSendAndDecoded(endpoint: endpoint,
                                                               method: .get,
                                                               payload: nil)
    }
    
    /**
      * Given: Requesting loyalty balance for a trip
      * When: The request succeeds with a loyalty balance burnable false
      * Then: Callback should be a success with a loyalty balance result
      */
    func testRequestSuccessWithBurnablePoints() {
        var capturedCallback: Result<LoyaltyStatus>?
        testObject.execute(callback: { capturedCallback = $0 })
        
        let loyaltyStatus = LoyaltyStatus(balance: 30, canBurn: true, canEarn: true)
        mockLoyaltyStatusRequest.triggerSuccessWithDecoded(value: loyaltyStatus)
        
        XCTAssertEqual(capturedCallback!.getSuccessValue()!.balance, 30)
        XCTAssertEqual(capturedCallback!.getSuccessValue()!.canBurn, true)
    }
    
    /**
     * Given: Requesting loyalty balance for a trip
     * When: The request succeeds with a loyalty balance burnable true
     * Then: Callback should be a success with a loyalty balance result
      */
    func testRequestSuccessWithoutBurnablePoints() {
        var capturedCallback: Result<LoyaltyStatus>?
        testObject.execute(callback: { capturedCallback = $0 })
        
        let loyaltyStatus = LoyaltyStatus(balance: 30, canBurn: false, canEarn: true)
        mockLoyaltyStatusRequest.triggerSuccessWithDecoded(value: loyaltyStatus)
        
        XCTAssertEqual(capturedCallback!.getSuccessValue()!.balance, 30)
        XCTAssertEqual(capturedCallback!.getSuccessValue()!.canBurn, false)
    }

    /**
      * Given: Requesting loyalty balance for a trip
      * When: The request fails
      * Then: Callback should be a fail with expected error
      */
    func testRequestFailure() {
        let expectedError = TestUtil.getRandomError()

        var capturedCallback: Result<LoyaltyBalance>?
        testObject.execute(callback: { capturedCallback = $0 })

        mockLoyaltyStatusRequest.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(capturedCallback!.getErrorValue()))
    }

    /**
      * When: Cancelling the request for loyalty balance
      * Then: Loyalty balancerequest should cancel
      */
    func testCancelRequest() {
        testObject.cancel()
        XCTAssertTrue(mockLoyaltyStatusRequest.cancelNetworkRequestCalled)
    }
}
