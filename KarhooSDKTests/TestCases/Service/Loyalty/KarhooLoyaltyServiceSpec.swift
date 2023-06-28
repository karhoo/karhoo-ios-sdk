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
    private var mockUserDataStore: MockUserDataStore!
    
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
        
        mockUserDataStore = MockUserDataStore()
        mockLoyaltyBalanceInteractor = MockLoyaltyBalanceInteractor()
        mockLoyaltyConversionInteractor = MockLoyaltyConversionInteractor()
        mockLoyaltyStatusInteractor = MockLoyaltyStatusInteractor()
        mockLoyaltyBurnInteractor = MockLoyaltyBurnInteractor()
        mockLoyaltyEarnInteractor = MockLoyaltyEarnInteractor()
        mockLoyaltyPreAuthInteractor = MockLoyaltyPreAuthInteractor()
        testObject = KarhooLoyaltyService(userDataStore: mockUserDataStore,
                                          loyaltyBalanceInteractor: mockLoyaltyBalanceInteractor,
                                          loyaltyConversionInteractor: mockLoyaltyConversionInteractor,
                                          loyaltyStatusInteractor: mockLoyaltyStatusInteractor,
                                          loyaltyBurnInteractor: mockLoyaltyBurnInteractor,
                                          loyaltyEarnInteractor: mockLoyaltyEarnInteractor,
                                          loyaltyPreAuthInteractor: mockLoyaltyPreAuthInteractor)
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

        XCTAssertEqual(10, result?.getSuccessValue()?.points)
        XCTAssertEqual(false, result?.getSuccessValue()?.burnable)
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

        XCTAssert(expectedError.equals(result?.getErrorValue()))
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

        XCTAssertEqual("123", result?.getSuccessValue()?.version)
        XCTAssertEqual("GBP", result?.getSuccessValue()?.rates[0].currency)
        XCTAssertEqual("10", result?.getSuccessValue()?.rates[0].points)
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

        XCTAssert(expectedError.equals(result?.getErrorValue()))
    }
    
    func testLoyaltyStatusSuccess() {
        let call = testObject.getLoyaltyStatus(identifier: identifier)
        
        var result: Result<LoyaltyStatus>?
        call.execute(callback: { result = $0 })
        
        mockLoyaltyStatusInteractor.triggerSuccess(result: loyaltyStatusMock)
        
        XCTAssertEqual(1000, result?.getSuccessValue()?.balance)
        XCTAssertEqual(false, result?.getSuccessValue()?.canBurn)
        XCTAssertEqual(true, result?.getSuccessValue()?.canEarn)
    }
    
    func testLoyaltyStatusFail() {
        let call = testObject.getLoyaltyStatus(identifier: identifier)
        
        var result: Result<LoyaltyStatus>?
        call.execute(callback: { result = $0 })
        
        let expectedError = TestUtil.getRandomError()
        mockLoyaltyStatusInteractor.triggerFail(error: expectedError)
        
        XCTAssert(expectedError.equals(result?.getErrorValue()))
    }
    
    func testLoyaltyBurnSuccess() {
        let call = testObject.getLoyaltyBurn(identifier: identifier, currency: currency, amount: amount)
        
        var result: Result<LoyaltyPoints>?
        call.execute(callback: { result = $0 })
        
        mockLoyaltyBurnInteractor.triggerSuccess(result: loyaltyPointsMock)
        
        XCTAssertEqual(10, result?.getSuccessValue()?.points)
    }
    
    func testLoyaltyBurnFail() {
        let call = testObject.getLoyaltyBurn(identifier: identifier, currency: currency, amount: amount)

        var result: Result<LoyaltyPoints>?
        call.execute(callback: { result = $0 })

        let expectedError = TestUtil.getRandomError()
        mockLoyaltyBurnInteractor.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result?.getErrorValue()))
    }
    
    func testLoyaltyEarnSuccess() {
        let call = testObject.getLoyaltyEarn(identifier: identifier, currency: currency, amount: amount, burnPoints: points)
        
        var result: Result<LoyaltyPoints>?
        call.execute(callback: { result = $0 })
        
        mockLoyaltyEarnInteractor.triggerSuccess(result: loyaltyPointsMock)
        
        XCTAssertEqual(10, result?.getSuccessValue()?.points)
    }
    
    func testLoyaltyEarnFail() {
        let call = testObject.getLoyaltyEarn(identifier: identifier, currency: currency, amount: amount, burnPoints: points)

        var result: Result<LoyaltyPoints>?
        call.execute(callback: { result = $0 })

        let expectedError = TestUtil.getRandomError()
        mockLoyaltyEarnInteractor.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result?.getErrorValue()))
    }
    
    func testLoyaltyPreAuthSuccess() {
        let call = testObject.getLoyaltyPreAuth(preAuthRequest: loyaltyPreAuthMock)
        
        var result: Result<LoyaltyNonce>?
        call.execute(callback: { result = $0 })
        
        mockLoyaltyPreAuthInteractor.triggerSuccess(result: loyaltyNonceMock)
        
        XCTAssertEqual("123A", result?.getSuccessValue()?.nonce)
    }
    
    func testLoyaltyPreAuthFail() {
        let call = testObject.getLoyaltyPreAuth(preAuthRequest: loyaltyPreAuthMock)

        var result: Result<LoyaltyNonce>?
        call.execute(callback: { result = $0 })

        let expectedError = TestUtil.getRandomError()
        mockLoyaltyPreAuthInteractor.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result?.getErrorValue()))
    }
}

