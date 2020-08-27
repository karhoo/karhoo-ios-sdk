//
//  AdyenPaymentsSpec.swift
//  KarhooSDKIntegrationTests
//
//  Created by Nurseda Balcioglu on 27/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

import XCTest
@testable import KarhooSDK

final class AdyenPaymentsSpec: XCTestCase {
    
    private var paymentService: PaymentService!
    private let path: String = "/v3/payments/adyen/payments"
    private var call: Call<AdyenTransaction>!
    
    override func setUp() {
        super.setUp()
        
        paymentService = KarhooPaymentService()
        
        call = paymentService.getAdyenPayments()
    }
    
    /**
     * When: Getting Adyen payments with card
     * And: The response returns successful
     * Then: Result is success
     */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "AdyenPaymentsWithCard.json", path: path)
        
        let expectation = self.expectation(description: "Callback called with succeess")
        
        call.execute(callback: { result in
            XCTAssertEqual("aaaa-aaaa-aaaa", result.successValue()?.transactionID)
            XCTAssertEqual(1000, result.successValue()?.payload.amount.value)
            XCTAssertEqual("853598516547275E", result.successValue()?.payload.pspReference)
            XCTAssertEqual("Authorised", result.successValue()?.payload.resultCode)
            XCTAssertEqual("Your order number", result.successValue()?.payload.merchantReference)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10)
    }
    
    /**
     * When: Getting Adyen payments with 3DS redirection
     * And: The response returns successful
     * Then: Result is success
     */
    func testHappyPathWith3DS() {
        NetworkStub.successResponse(jsonFile: "AdyenPaymentsWith3DS.json", path: path)
        
        let expectation = self.expectation(description: "Callback called with succeess")
        
        call.execute(callback: { result in
            XCTAssertEqual("aaaa-aaaa-aaaa", result.successValue()?.transactionID)
            XCTAssertEqual("RedirectShopper", result.successValue()?.payload.resultCode)
            XCTAssertEqual("scheme", result.successValue()?.payload.action.paymentMethodType)
            XCTAssertEqual("https://test.adyen.com/hpp/3d/validate.shtml", result.successValue()?.payload.action.url)
            XCTAssertEqual("POST", result.successValue()?.payload.action.method)
            XCTAssertEqual("redirect", result.successValue()?.payload.action.type)
            XCTAssertEqual("mockPaymentData", result.successValue()?.payload.action.paymentData)
            
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10)
    }
    
    
    /**
     * When: Getting Adyen payments
     * And: The response returns error K0001
     * Then: Resulting error value should be a generalRequestError
     */
    func testErrorResponse() {
        let expectedError = RawKarhooErrorFactory.buildError(code: "K0001")
        
        NetworkStub.errorResponse(path: path, responseData: expectedError)
        
        let expectation = self.expectation(description: "calls callback with error result")
        
        call.execute(callback: { result in
            XCTAssertEqual(.generalRequestError, result.errorValue()!.type)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1)
    }
    
    /**
     * When: Getting Adyen payment methods
     * And: The response returns time out error
     * Then: Result is error
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: path)
        
        let expectation = self.expectation(description: "calls the callback with error")
        
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1)
    }
    
}
