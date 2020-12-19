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
    private var mockLoyaltyConversionInteractor: MockLoyaltyConversionInteractor!
    
    private let identifier = "some_id"
    static let ratesMock = LoyaltyRates(currency: "GBP", points: "10")
    private let loyaltyConversionMock = LoyaltyConversion(version: "123", rates: [ratesMock])
    private let loyaltyBalanceMock = LoyaltyBalance(points: 10, burnable: false)
    
    override func setUp() {
        super.setUp()
        
        mockLoyaltyBalanceInteractor = MockLoyaltyBalanceInteractor()
        mockLoyaltyConversionInteractor = MockLoyaltyConversionInteractor()
        testObject = KarhooLoyaltyService(loyaltyBalanceInteractor: mockLoyaltyBalanceInteractor,
                                          loyaltyConversionInteractor: mockLoyaltyConversionInteractor)
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
    
    /**
      * When: Loyalty conversion succeeds
      * Then: callback should be executed with expected value
      */
    func testLoyaltyConversionSucces() {
        let call = testObject.getLoyaltyConversion(identifier: identifier)
        
        var result: Result<LoyaltyConversion>?
        call.execute(callback: { result = $0 })

        mockLoyaltyConversionInteractor.triggerSuccess(result: loyaltyConversionMock)

        XCTAssertEqual("123", result?.successValue()?.version)
        XCTAssertEqual("GBP", result?.successValue()?.rates[0].currency)
        XCTAssertEqual("10", result?.successValue()?.rates[0].points)
    }

    /**
     * When: Loyalty conversion fails
     * Then: callback should be executed with expected value
     */
    func testLoyaltyConversionFail() {
        let call = testObject.getLoyaltyConversion(identifier: identifier)

        var result: Result<LoyaltyConversion>?
        call.execute(callback: { result = $0 })

        let expectedError = TestUtil.getRandomError()
        mockLoyaltyConversionInteractor.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result?.errorValue()))
    }
}

