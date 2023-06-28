//
//  KarhooLoyaltyBalanceInteractorSpec.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 17/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooLoyaltyBalanceInteractorSpec: XCTestCase {

    private var mockLoyaltyBalanceRequest: MockRequestSender!
    private var testObject: KarhooLoyaltyBalanceInteractor!

    private let identifier = "some_id"
    
    private let loyaltyBalanceMock = LoyaltyBalance(points: 10, burnable: false)
    
    override func setUp() {
        super.setUp()
        
        mockLoyaltyBalanceRequest = MockRequestSender()
        
        testObject = KarhooLoyaltyBalanceInteractor(requestSender: mockLoyaltyBalanceRequest)
        testObject.set(identifier: identifier)
    }
    
    /**
     * When: Making a request to loyalty balance
     * Then: Expected method, path and payload should be set
     */

    func testRequestFormat() {
        testObject.execute(callback: { (_:Result<KarhooVoid>) in  })

        let endpoint = APIEndpoint.loyaltyBalance(identifier: identifier)

        mockLoyaltyBalanceRequest.assertRequestSendAndDecoded(endpoint: endpoint,
                                                               method: .get,
                                                               payload: nil)
    }
    
    /**
      * Given: Requesting loyalty balance for a trip
      * When: The request succeeds with a loyalty balance burnable false
      * Then: Callback should be a success with a loyalty balance result
      */
    func testRequestSuccessWithBurnablePoints() {
        var capturedCallback: Result<LoyaltyBalance>?
        testObject.execute(callback: { capturedCallback = $0 })
        
        let loyaltyBalance = LoyaltyBalance(points: 10, burnable: false)
        mockLoyaltyBalanceRequest.triggerSuccessWithDecoded(value: loyaltyBalance)
        
        XCTAssertEqual(capturedCallback!.getSuccessValue()!.points, 10)
        XCTAssertEqual(capturedCallback!.getSuccessValue()!.burnable, false)
    }
    
    /**
     * Given: Requesting loyalty balance for a trip
     * When: The request succeeds with a loyalty balance burnable true
     * Then: Callback should be a success with a loyalty balance result
      */
    func testRequestSuccessWithoutBurnablePoints() {
        var capturedCallback: Result<LoyaltyBalance>?
        testObject.execute(callback: { capturedCallback = $0 })
        
        let loyaltyBalance = LoyaltyBalance(points: 10, burnable: true)
        mockLoyaltyBalanceRequest.triggerSuccessWithDecoded(value: loyaltyBalance)
        
        XCTAssertEqual(capturedCallback!.getSuccessValue()!.points, 10)
        XCTAssertEqual(capturedCallback!.getSuccessValue()!.burnable, true)
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

        mockLoyaltyBalanceRequest.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(capturedCallback!.getErrorValue()))
    }

    /**
      * When: Cancelling the request for loyalty balance
      * Then: Loyalty balancerequest should cancel
      */
    func testCancelRequest() {
        testObject.cancel()
        XCTAssertTrue(mockLoyaltyBalanceRequest.cancelNetworkRequestCalled)
    }
}
