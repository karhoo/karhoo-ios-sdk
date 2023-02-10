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
    private let supplyPartnerId = "SPID"
    private var call: Call<AdyenPayments>!
    
    override func setUp() {
        super.setUp()
        
        paymentService = KarhooPaymentService()
        call = paymentService.adyenPayments(request: AdyenPaymentsRequest(supplyPartnerID: supplyPartnerId))
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
            XCTAssertEqual("aaaa-aaaa-aaaa", result.successValue()?.tripId)
            XCTAssertNotNil(result.successValue()?.payload)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1.50)
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
        
        waitForExpectations(timeout: 1.5)
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
        
        waitForExpectations(timeout: 1.5)
    }
}
