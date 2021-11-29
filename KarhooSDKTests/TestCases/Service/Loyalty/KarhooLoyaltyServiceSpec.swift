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
    private var mockLoyaltyStatusInteractor: MockLoyaltyStatusInteractor!
    private var mockLoyaltyBurnInteractor: MockLoyaltyBurnInteractor!
    private var mockLoyaltyEarnInteractor: MockLoyaltyEarnInteractor!
    private var mockLoyaltyPreAuthInteractor: MockLoyaltyPreAuthInteractor!
    private var mockLoyaltyRefreshCurrentStatusInteractor: MockLoyaltyRefreshCurrentStatusInteractor!
    
    private let identifier = "some_id"
    private let currency = "GBP"
    private let amount = 10
    private let points = 10
    static let ratesMock = LoyaltyRates(currency: "GBP", points: "10")
    private let loyaltyConversionMock = LoyaltyConversion(version: "123", rates: [ratesMock])
    private let loyaltyBalanceMock = LoyaltyBalance(points: 10, burnable: false)
    private let loyaltyStatusMock = LoyaltyStatus(balance: 1000, canBurn: false, canEarn: true)
    private let loyaltyPointsMock = LoyaltyPoints(points: 10)
    private let loyaltyPreAuthMock = LoyaltyPreAuth(identifier: "123A", currency: "GBP", points: 100, flexpay: false, membership: "123A")
    private let loyaltyNonceMock = LoyaltyNonce(loyaltyNonce: "123A")
    
    override func setUp() {
        super.setUp()
        
        mockLoyaltyBalanceInteractor = MockLoyaltyBalanceInteractor()
        mockLoyaltyConversionInteractor = MockLoyaltyConversionInteractor()
        mockLoyaltyStatusInteractor = MockLoyaltyStatusInteractor()
        mockLoyaltyBurnInteractor = MockLoyaltyBurnInteractor()
        mockLoyaltyEarnInteractor = MockLoyaltyEarnInteractor()
        mockLoyaltyPreAuthInteractor = MockLoyaltyPreAuthInteractor()
        mockLoyaltyRefreshCurrentStatusInteractor = MockLoyaltyRefreshCurrentStatusInteractor()
        testObject = KarhooLoyaltyService(loyaltyBalanceInteractor: mockLoyaltyBalanceInteractor,
                                          loyaltyConversionInteractor: mockLoyaltyConversionInteractor,
                                          loyaltyStatusInteractor: mockLoyaltyStatusInteractor,
                                          loyaltyBurnInteractor: mockLoyaltyBurnInteractor,
                                          loyaltyEarnInteractor: mockLoyaltyEarnInteractor,
                                          loyaltyPreAuthInteractor: mockLoyaltyPreAuthInteractor,
                                          loyaltyRefreshCurrentStatusInteractor: mockLoyaltyRefreshCurrentStatusInteractor)
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
    
    func testLoyaltyStatusSuccess() {
        let call = testObject.getLoyaltyStatus(identifier: identifier)
        
        var result: Result<LoyaltyStatus>?
        call.execute(callback: { result = $0 })
        
        mockLoyaltyStatusInteractor.triggerSuccess(result: loyaltyStatusMock)
        
        XCTAssertEqual(1000, result?.successValue()?.balance)
        XCTAssertEqual(false, result?.successValue()?.canBurn)
        XCTAssertEqual(true, result?.successValue()?.canEarn)
    }
    
    func testLoyaltyStatusFail() {
        let call = testObject.getLoyaltyStatus(identifier: identifier)
        
        var result: Result<LoyaltyStatus>?
        call.execute(callback: { result = $0 })
        
        let expectedError = TestUtil.getRandomError()
        mockLoyaltyStatusInteractor.triggerFail(error: expectedError)
        
        XCTAssert(expectedError.equals(result?.errorValue()))
    }
    
    func testLoyaltyBurnSuccess() {
        let call = testObject.getLoyaltyBurn(identifier: identifier, currency: currency, amount: amount)
        
        var result: Result<LoyaltyPoints>?
        call.execute(callback: { result = $0 })
        
        mockLoyaltyBurnInteractor.triggerSuccess(result: loyaltyPointsMock)
        
        XCTAssertEqual(10, result?.successValue()?.points)
    }
    
    func testLoyaltyBurnFail() {
        let call = testObject.getLoyaltyBurn(identifier: identifier, currency: currency, amount: amount)

        var result: Result<LoyaltyPoints>?
        call.execute(callback: { result = $0 })

        let expectedError = TestUtil.getRandomError()
        mockLoyaltyBurnInteractor.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result?.errorValue()))
    }
    
    func testLoyaltyEarnSuccess() {
        let call = testObject.getLoyaltyEarn(identifier: identifier, currency: currency, amount: amount, burnPoints: points)
        
        var result: Result<LoyaltyPoints>?
        call.execute(callback: { result = $0 })
        
        mockLoyaltyEarnInteractor.triggerSuccess(result: loyaltyPointsMock)
        
        XCTAssertEqual(10, result?.successValue()?.points)
    }
    
    func testLoyaltyEarnFail() {
        let call = testObject.getLoyaltyEarn(identifier: identifier, currency: currency, amount: amount, burnPoints: points)

        var result: Result<LoyaltyPoints>?
        call.execute(callback: { result = $0 })

        let expectedError = TestUtil.getRandomError()
        mockLoyaltyEarnInteractor.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result?.errorValue()))
    }
    
    func testLoyaltyPreAuthSuccess() {
        let call = testObject.getLoyaltyPreAuth(preAuthRequest: loyaltyPreAuthMock)
        
        var result: Result<LoyaltyNonce>?
        call.execute(callback: { result = $0 })
        
        mockLoyaltyPreAuthInteractor.triggerSuccess(result: loyaltyNonceMock)
        
        XCTAssertEqual("123A", result?.successValue()?.loyaltyNonce)
    }
    
    func testLoyaltyPreAuthFail() {
        let call = testObject.getLoyaltyPreAuth(preAuthRequest: loyaltyPreAuthMock)

        var result: Result<LoyaltyNonce>?
        call.execute(callback: { result = $0 })

        let expectedError = TestUtil.getRandomError()
        mockLoyaltyPreAuthInteractor.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result?.errorValue()))
    }
    
    func testLoyaltyRefreshStatusSuccess() {
        let call = testObject.refreshCurrentLoyaltyStatus(identifier: identifier)
        
        var result: Result<LoyaltyStatus>?
        call.execute(callback: { result = $0 })
        
        mockLoyaltyRefreshCurrentStatusInteractor.triggerSuccess(result: loyaltyStatusMock)
        
        XCTAssertEqual(1000, result?.successValue()?.balance)
        XCTAssertEqual(false, result?.successValue()?.canBurn)
        XCTAssertEqual(true, result?.successValue()?.canEarn)
    }
    
    func testLoyaltyRefreshStatusFail() {
        let call = testObject.refreshCurrentLoyaltyStatus(identifier: identifier)
        
        var result: Result<LoyaltyStatus>?
        call.execute(callback: { result = $0 })
        
        let expectedError = TestUtil.getRandomError()
        mockLoyaltyRefreshCurrentStatusInteractor.triggerFail(error: expectedError)
        
        XCTAssert(expectedError.equals(result?.errorValue()))
    }
}

