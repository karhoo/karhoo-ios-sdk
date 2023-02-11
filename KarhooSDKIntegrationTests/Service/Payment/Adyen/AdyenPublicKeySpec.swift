//
//  AdyenPublicKeySpec.swift
//  KarhooSDKIntegrationTests
//
//  Created by Nurseda Balcioglu on 15/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class AdyenPublicKeySpec: XCTestCase {
    
    private var paymentService: PaymentService!
    private let path: String = "/v3/payments/adyen/public-key"
    private var call: Call<AdyenPublicKey>!
    
    override func setUp() {
        super.setUp()
        
        paymentService = KarhooPaymentService()
        call = paymentService.getAdyenPublicKey()
    }
    
    /**
     * When: Getting Adyen payments with card
     * And: The response returns successful
     * Then: Result is success
     */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "AdyenPublicKey.json", path: path)
        
        let expectation = self.expectation(description: "Callback called with succeess")
        
        call.execute(callback: { result in
            XCTAssertEqual("aaaa-aaaa-aaaa", result.getSuccessValue()?.key)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 100)
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
            XCTAssertEqual(.generalRequestError, result.getErrorValue()!.type)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10)
    }
    
    /**
     * When: Getting Adyen public key
     * And: The response returns time out error
     * Then: Result is error
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: path)
        
        let expectation = self.expectation(description: "calls the callback with error")
        
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10)
    }
}

