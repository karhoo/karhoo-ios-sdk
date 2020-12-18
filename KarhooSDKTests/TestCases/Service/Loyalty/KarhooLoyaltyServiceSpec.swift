//
//  KarhooLoyaltyServiceSpec.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 17/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class KarhooLoyaltyServiceSpec: XCTestCase {
    
    private var testObject: KarhooLoyaltyService!
    private var mockLoyaltyBalanceInteractor: MockLoyaltyBalanceInteractor!
    
    private let identifier = "some_id"
    
    private let loyaltyBalanceMock = LoyaltyBalance(points: 10, burnable: false)
    
    override func setUp() {
        super.setUp()
        
        mockLoyaltyBalanceInteractor = MockLoyaltyBalanceInteractor()
        testObject = KarhooLoyaltyService(loyaltyBalanceInteractor: mockLoyaltyBalanceInteractor)
    }
    
    /**
      * When: Loyalty balance succeeds
      * Then: callback should be executed with expected value
      */
    func testLoyaltyBalanceSucces() {
        let call = testObject.getLoyaltyBalance(identifier: identifier)
        
        var result: Result<LoyaltyBalance>?
        call.execute(callback: { result = $0 })

        mockLoyaltyBalanceInteractor.triggerSuccess(result: loyaltyBalanceMock)

        XCTAssertEqual(10, result?.successValue()?.points)
        XCTAssertEqual(false, result?.successValue()?.burnable)
    }

    /**
     * When: Loyalty balance fails
     * Then: callback should be executed with expected value
     */
    func testLoyaltyBalanceFail() {
        let call = testObject.getLoyaltyBalance(identifier: identifier)

        var result: Result<LoyaltyBalance>?
        call.execute(callback: { result = $0 })

        let expectedError = TestUtil.getRandomError()
        mockLoyaltyBalanceInteractor.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result?.errorValue()))
    }
}

